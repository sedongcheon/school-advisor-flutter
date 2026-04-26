import 'package:freezed_annotation/freezed_annotation.dart';

part 'law_dto.freezed.dart';
part 'law_dto.g.dart';

/// `GET /api/v1/laws` 응답.
@freezed
abstract class LawArticle with _$LawArticle {
  const factory LawArticle({
    @JsonKey(name: 'law_name') required String lawName,
    @JsonKey(name: 'article_no') required String articleNo,
    String? title,
    @JsonKey(name: 'doc_type') required String docType,
    required String content,
    @JsonKey(name: 'effective_date') String? effectiveDate,
    @JsonKey(name: 'source_url') String? sourceUrl,
  }) = _LawArticle;

  factory LawArticle.fromJson(Map<String, dynamic> json) =>
      _$LawArticleFromJson(json);
}
