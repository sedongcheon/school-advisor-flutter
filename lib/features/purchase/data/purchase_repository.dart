import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';
import '../../user/data/user_status_dto.dart';

/// 백엔드 결제 검증 결과.
class PurchaseVerifyResult {
  const PurchaseVerifyResult({required this.status});
  final UserStatus status;
}

/// 백엔드 결제 검증 실패 사유.
sealed class PurchaseVerifyError implements Exception {
  const PurchaseVerifyError(this.message);
  final String message;
}

class PurchaseTokenInvalid extends PurchaseVerifyError {
  const PurchaseTokenInvalid([super.message = 'invalid_token']);
}

class PurchaseTokenAlreadyUsed extends PurchaseVerifyError {
  const PurchaseTokenAlreadyUsed([
    super.message = 'purchase_token_already_used',
  ]);
}

class PurchaseProviderError extends PurchaseVerifyError {
  const PurchaseProviderError([super.message = 'provider_error']);
}

class PurchaseUnknownError extends PurchaseVerifyError {
  const PurchaseUnknownError([super.message = 'unknown']);
}

abstract interface class PurchaseRepository {
  /// `POST /api/v1/purchase/verify` — 영수증 검증 + 엔타이틀먼트 갱신.
  Future<PurchaseVerifyResult> verify({
    required String platform,
    required String productId,
    required String purchaseToken,
  });
}

class PurchaseRepositoryImpl implements PurchaseRepository {
  PurchaseRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<PurchaseVerifyResult> verify({
    required String platform,
    required String productId,
    required String purchaseToken,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/purchase/verify',
        data: {
          'platform': platform,
          'product_id': productId,
          'purchase_token': purchaseToken,
        },
      );
      return PurchaseVerifyResult(status: UserStatus.fromJson(res.data!));
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      switch (code) {
        case 400:
        case 422:
          throw const PurchaseTokenInvalid();
        case 402:
          throw const PurchaseTokenInvalid();
        case 409:
          throw const PurchaseTokenAlreadyUsed();
        case 502:
          throw const PurchaseProviderError();
        default:
          throw const PurchaseUnknownError();
      }
    }
  }
}

final purchaseRepositoryProvider = FutureProvider<PurchaseRepository>((
  ref,
) async {
  final dio = await ref.watch(dioProvider.future);
  return PurchaseRepositoryImpl(dio);
});
