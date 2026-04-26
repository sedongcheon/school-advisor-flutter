import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// `flutter_secure_storage` 의 키. 앱 재설치 시까지 유지된다.
const String _deviceIdKey = 'school_advisor_device_id';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

/// Device ID 를 비동기로 로드/생성한다.
///
/// - 저장된 값이 있으면 그대로 반환
/// - 없으면 UUID v4 생성 후 저장하고 반환
final deviceIdProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final cached = await storage.read(key: _deviceIdKey);
  if (cached != null && cached.isNotEmpty) {
    return cached;
  }
  final fresh = const Uuid().v4();
  await storage.write(key: _deviceIdKey, value: fresh);
  return fresh;
});
