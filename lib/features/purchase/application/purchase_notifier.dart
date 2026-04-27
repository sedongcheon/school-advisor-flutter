import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../user/data/user_repository.dart';
import '../data/purchase_product.dart';
import '../data/purchase_repository.dart';

/// 결제 화면의 상태.
class PurchaseState {
  const PurchaseState({
    this.isLoading = true,
    this.storeAvailable = false,
    this.products = const [],
    this.activePurchaseId,
    this.error,
    this.lastSuccessProductId,
  });

  final bool isLoading;
  final bool storeAvailable;
  final List<ProductDetails> products;

  /// 현재 결제 진행 중인 productId. UI 가 해당 카드만 비활성화.
  final String? activePurchaseId;

  /// 사용자 노출용 마지막 에러 문구. 표시 후 null 로 reset.
  final String? error;

  /// 마지막 성공한 productId (스낵바/토스트에 사용 후 null 로 reset).
  final String? lastSuccessProductId;

  PurchaseState copyWith({
    bool? isLoading,
    bool? storeAvailable,
    List<ProductDetails>? products,
    String? activePurchaseId,
    Object? error = _sentinel,
    Object? lastSuccessProductId = _sentinel,
  }) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      storeAvailable: storeAvailable ?? this.storeAvailable,
      products: products ?? this.products,
      activePurchaseId: activePurchaseId ?? this.activePurchaseId,
      error: identical(error, _sentinel) ? this.error : error as String?,
      lastSuccessProductId: identical(lastSuccessProductId, _sentinel)
          ? this.lastSuccessProductId
          : lastSuccessProductId as String?,
    );
  }
}

const Object _sentinel = Object();

final purchaseNotifierProvider =
    NotifierProvider<PurchaseNotifier, PurchaseState>(PurchaseNotifier.new);

class PurchaseNotifier extends Notifier<PurchaseState> {
  late final InAppPurchase _iap;
  StreamSubscription<List<PurchaseDetails>>? _streamSub;

  @override
  PurchaseState build() {
    _iap = InAppPurchase.instance;
    ref.onDispose(() {
      _streamSub?.cancel();
    });
    Future.microtask(_initialize);
    return const PurchaseState();
  }

  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      state = state.copyWith(isLoading: false, storeAvailable: false);
      return;
    }

    _streamSub ??= _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _streamSub?.cancel(),
      onError: (Object e) {
        debugPrint('[purchase] stream error: $e');
        state = state.copyWith(
          error: '결제 스트림에 오류가 발생했어요.',
          activePurchaseId: null,
        );
      },
    );

    final response = await _iap.queryProductDetails(kPurchaseProductIds);
    if (response.error != null) {
      debugPrint('[purchase] queryProductDetails error: ${response.error}');
    }
    state = state.copyWith(
      isLoading: false,
      storeAvailable: true,
      products: response.productDetails,
    );
  }

  Future<void> buy(ProductDetails product) async {
    if (state.activePurchaseId != null) return;
    state = state.copyWith(activePurchaseId: product.id, error: null);
    try {
      // 구독은 buyNonConsumable 로 시작 (Play 가 자동으로 구독 흐름 진입).
      await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
    } on Object catch (e) {
      debugPrint('[purchase] buyNonConsumable failed: $e');
      state = state.copyWith(
        activePurchaseId: null,
        error: '결제 창을 띄울 수 없어요. 잠시 후 다시 시도해 주세요.',
      );
    }
  }

  /// 사용자 노출 메시지를 한 번 보여준 뒤 reset.
  void clearError() => state = state.copyWith(error: null);
  void clearLastSuccess() => state = state.copyWith(lastSuccessProductId: null);

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> updates) async {
    for (final p in updates) {
      switch (p.status) {
        case PurchaseStatus.pending:
          // Play 결제 다이얼로그가 열린 상태 — 그대로 대기
          break;
        case PurchaseStatus.canceled:
          state = state.copyWith(activePurchaseId: null);
        case PurchaseStatus.error:
          debugPrint('[purchase] update error: ${p.error}');
          state = state.copyWith(
            activePurchaseId: null,
            error: '결제가 완료되지 않았어요. 다시 시도해 주세요.',
          );
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndAcknowledge(p);
      }

      if (p.pendingCompletePurchase) {
        await _iap.completePurchase(p);
      }
    }
  }

  Future<void> _verifyAndAcknowledge(PurchaseDetails purchase) async {
    final productId = purchase.productID;
    final token = purchase.verificationData.serverVerificationData;
    try {
      final repo = await ref.read(purchaseRepositoryProvider.future);
      final result = await repo.verify(
        platform: Platform.isIOS ? 'ios' : 'android',
        productId: productId,
        purchaseToken: token,
      );

      // 사용량 인디케이터에 즉시 반영 (실패해도 다음 폴링 때 갱신되므로 fire-and-forget)
      unawaited(ref.read(userStatusProvider.notifier).refresh());

      // 화면 사용용 상태 갱신
      state = state.copyWith(
        activePurchaseId: null,
        lastSuccessProductId: productId,
        error: null,
      );

      // 검증 성공 응답에 plan 정보 포함됨 (디버그 로그)
      debugPrint(
        '[purchase] verified: plan=${result.status.plan} '
        'used=${result.status.questionsUsed}/${result.status.questionsLimit}',
      );
    } on PurchaseTokenAlreadyUsed {
      state = state.copyWith(
        activePurchaseId: null,
        error: '이미 사용된 결제예요. 고객센터에 문의해 주세요.',
      );
    } on PurchaseTokenInvalid {
      state = state.copyWith(
        activePurchaseId: null,
        error: '결제 영수증이 유효하지 않아요. 다시 시도해 주세요.',
      );
    } on PurchaseProviderError {
      state = state.copyWith(
        activePurchaseId: null,
        error: '결제 검증 서버가 일시적으로 응답하지 않아요. 잠시 후 다시 시도해 주세요.',
      );
    } on Object catch (e) {
      debugPrint('[purchase] verify failed: $e');
      state = state.copyWith(
        activePurchaseId: null,
        error: '결제 검증 중 알 수 없는 오류가 발생했어요.',
      );
    }
  }
}
