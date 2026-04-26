import 'package:freezed_annotation/freezed_annotation.dart';

part 'law_index_dto.freezed.dart';
part 'law_index_dto.g.dart';

/// 자산 `assets/laws/index.json` 의 최상위 모델.
@freezed
abstract class LawIndex with _$LawIndex {
  const factory LawIndex({
    required int version,
    required List<LawGroup> groups,
  }) = _LawIndex;

  factory LawIndex.fromJson(Map<String, dynamic> json) =>
      _$LawIndexFromJson(json);
}

@freezed
abstract class LawGroup with _$LawGroup {
  const factory LawGroup({
    @JsonKey(name: 'law_name') required String lawName,
    @JsonKey(name: 'short_name') required String shortName,
    @JsonKey(name: 'doc_type') required String docType,
    required List<LawArticleEntry> articles,
  }) = _LawGroup;

  factory LawGroup.fromJson(Map<String, dynamic> json) =>
      _$LawGroupFromJson(json);
}

@freezed
abstract class LawArticleEntry with _$LawArticleEntry {
  const factory LawArticleEntry({
    @JsonKey(name: 'article_no') required String articleNo,
    required String title,
  }) = _LawArticleEntry;

  factory LawArticleEntry.fromJson(Map<String, dynamic> json) =>
      _$LawArticleEntryFromJson(json);
}
