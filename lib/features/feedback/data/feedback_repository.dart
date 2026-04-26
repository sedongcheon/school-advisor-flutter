import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';
import 'feedback_dto.dart';

abstract interface class FeedbackRepository {
  /// 신고 전송. `rating` 은 1 로 자동 주입.
  Future<void> report({
    required String conversationId,
    required ReportReason reason,
    String? comment,
  });

  /// 별점 평가 전송. issue_type 은 null.
  Future<void> sendRating({
    required String conversationId,
    required int rating,
    String? comment,
  });
}

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> report({
    required String conversationId,
    required ReportReason reason,
    String? comment,
  }) async {
    final body = FeedbackRequestDto(
      conversationId: conversationId,
      rating: 1,
      issueType: reason.code,
      comment: comment,
    );
    await _dio.post<dynamic>('/api/v1/feedback', data: body.toJson());
  }

  @override
  Future<void> sendRating({
    required String conversationId,
    required int rating,
    String? comment,
  }) async {
    assert(rating >= 1 && rating <= 5, 'rating 은 1~5 범위여야 합니다.');
    final body = FeedbackRequestDto(
      conversationId: conversationId,
      rating: rating,
      comment: comment,
    );
    await _dio.post<dynamic>('/api/v1/feedback', data: body.toJson());
  }
}

final feedbackRepositoryProvider = FutureProvider<FeedbackRepository>((
  ref,
) async {
  final dio = await ref.watch(dioProvider.future);
  return FeedbackRepositoryImpl(dio);
});
