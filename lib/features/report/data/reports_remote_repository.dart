import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';

/// 백엔드 `/api/v1/reports` (예정) 호출 래퍼.
///
/// **현재 상태**: 백엔드 엔드포인트 미구현. 모든 메서드가 [debugPrint] 만
/// 남기고 본문 없이 반환한다. 백엔드가 준비되면 아래 TODO 부분만 활성화
/// 하면 된다 — 호출 스펙은 클라이언트 모델과 사전 합의된 매핑을 따른다.
///
/// ## 예상 호출 스펙 (백엔드 준비 시)
///
/// ```http
/// POST /api/v1/reports
///   X-Device-ID: <uuid>
///   { receipt_no, role, grade_band, types, when_label, where_label,
///     body, anonymous, status_code, created_at, updated_at }
///   → 201 + { receipt_no }
///
/// PATCH /api/v1/reports/{receipt_no}
///   { status_code }
///   → 200
///
/// DELETE /api/v1/reports/{receipt_no}
///   → 204
/// ```
class ReportsRemoteRepository {
  ReportsRemoteRepository(this._dio);
  // ignore: unused_field
  final Dio _dio;

  Future<void> create({
    required String receiptNo,
    required String role,
    required String gradeBand,
    required List<String> types,
    required String whenLabel,
    required String whereLabel,
    required String body,
    required bool anonymous,
  }) async {
    debugPrint('[reports-remote] (stub) create $receiptNo');
    // TODO(reports-backend): 백엔드 준비 후 활성화
    // await _dio.post<dynamic>('/api/v1/reports', data: {
    //   'receipt_no': receiptNo,
    //   'role': role,
    //   'grade_band': gradeBand,
    //   'types': types,
    //   'when_label': whenLabel,
    //   'where_label': whereLabel,
    //   'body': body,
    //   'anonymous': anonymous,
    // });
  }

  Future<void> updateStatus({
    required String receiptNo,
    required String statusCode,
  }) async {
    debugPrint('[reports-remote] (stub) updateStatus $receiptNo → $statusCode');
    // TODO(reports-backend):
    // await _dio.patch<dynamic>(
    //   '/api/v1/reports/$receiptNo',
    //   data: {'status_code': statusCode},
    // );
  }

  Future<void> delete(String receiptNo) async {
    debugPrint('[reports-remote] (stub) delete $receiptNo');
    // TODO(reports-backend):
    // await _dio.delete<dynamic>('/api/v1/reports/$receiptNo');
  }
}

final reportsRemoteRepositoryProvider = FutureProvider<ReportsRemoteRepository>(
  (ref) async {
    final dio = await ref.watch(dioProvider.future);
    return ReportsRemoteRepository(dio);
  },
);
