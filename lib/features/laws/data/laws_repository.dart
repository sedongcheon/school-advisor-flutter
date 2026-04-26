import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';
import 'law_dto.dart';

abstract interface class LawsRepository {
  /// 법령 조문을 조회한다. 404 면 null.
  Future<LawArticle?> fetchArticle({
    required String lawName,
    required String articleNo,
    CancelToken? cancelToken,
  });
}

class LawsRepositoryImpl implements LawsRepository {
  LawsRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<LawArticle?> fetchArticle({
    required String lawName,
    required String articleNo,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/v1/laws',
        queryParameters: {'law': lawName, 'article_no': articleNo},
        cancelToken: cancelToken,
      );
      final data = res.data;
      if (data == null) return null;
      return LawArticle.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}

final lawsRepositoryProvider = FutureProvider<LawsRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return LawsRepositoryImpl(dio);
});
