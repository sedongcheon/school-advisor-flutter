import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_options.dart';
import '../http/dio_provider.dart';
import 'notification_payload.dart';

/// 알림 탭으로 도달한 페이로드를 라우터가 처리할 때까지 잠시 보관.
/// 라우터 측이 처리 후 `null` 로 reset 한다.
final pendingPushPayloadProvider = StateProvider<NotificationPayload?>(
  (ref) => null,
);

/// FCM 토큰 발급, 권한 요청, 메시지 핸들러를 관리.
///
/// 권한 토글은 `notificationsEnabledProvider` 가 제어한다.
/// 토큰 발급/리프레시 시 백엔드 `POST /api/v1/user/push_token` 으로 등록한다.
class PushMessagingService {
  PushMessagingService(this.ref);

  final Ref ref;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;
  StreamSubscription<String>? _onTokenSub;

  static const _androidChannel = AndroidNotificationChannel(
    'general',
    '일반 알림',
    description: '학교폭력 관련 일반 공지·법령 개정 알림',
    importance: Importance.high,
  );

  Future<void> ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  /// 사용자가 설정에서 알림을 ON 으로 토글한 시점에 호출.
  Future<bool> enable() async {
    await ensureFirebaseInitialized();

    // 시스템 권한 요청 (iOS / Android 13+)
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    if (!granted) {
      debugPrint('[push] permission denied: ${settings.authorizationStatus}');
      return false;
    }

    await _initLocalNotifications();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    _onMessageSub ??= FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    _onMessageOpenedSub ??= FirebaseMessaging.onMessageOpenedApp.listen(
      _onMessageOpenedApp,
    );
    _onTokenSub ??= FirebaseMessaging.instance.onTokenRefresh.listen(
      _postTokenToBackend,
    );

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      debugPrint('[push] FCM token: $token');
      await _postTokenToBackend(token);
    }

    // 종료 상태에서 알림 탭으로 시작된 경우 페이로드 처리
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _handlePayload(initial.data);
    }
    return true;
  }

  /// 사용자가 설정에서 알림을 OFF 로 토글하면 토큰을 무효화한다.
  Future<void> disable() async {
    await _onMessageSub?.cancel();
    _onMessageSub = null;
    await _onMessageOpenedSub?.cancel();
    _onMessageOpenedSub = null;
    await _onTokenSub?.cancel();
    _onTokenSub = null;
    try {
      await FirebaseMessaging.instance.deleteToken();
    } on Object catch (e) {
      debugPrint('[push] deleteToken failed: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      init,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null) return;
        // payload 는 JSON 인코딩된 `data` 맵.
        // 본 구현에선 단순화를 위해 onMessage 의 data 를 다이렉트로 사용.
      },
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handlePayload(message.data);
  }

  void _handlePayload(Map<String, dynamic> data) {
    final payload = NotificationPayload.from(data);
    if (payload == null) return;
    ref.read(pendingPushPayloadProvider.notifier).state = payload;
  }

  /// 백엔드 `POST /api/v1/user/push_token` 호출. 실패해도 non-blocking.
  Future<void> _postTokenToBackend(String token) async {
    try {
      final dio = await ref.read(dioProvider.future);
      await dio.post<dynamic>(
        '/api/v1/user/push_token',
        data: {'token': token},
      );
    } on Object catch (e) {
      debugPrint('[push] post token failed (non-blocking): $e');
    }
  }
}

final pushMessagingServiceProvider = Provider<PushMessagingService>((ref) {
  final svc = PushMessagingService(ref);
  ref.onDispose(svc.disable);
  return svc;
});
