import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq_dto.freezed.dart';
part 'faq_dto.g.dart';

/// `assets/faq/faq_seed.json` 의 최상위 모델.
@freezed
abstract class FaqIndex with _$FaqIndex {
  const factory FaqIndex({
    required int version,
    required List<FaqCategory> categories,
  }) = _FaqIndex;

  factory FaqIndex.fromJson(Map<String, dynamic> json) =>
      _$FaqIndexFromJson(json);
}

@freezed
abstract class FaqCategory with _$FaqCategory {
  const factory FaqCategory({
    required String id,
    required String label,
    required List<FaqItem> items,
  }) = _FaqCategory;

  factory FaqCategory.fromJson(Map<String, dynamic> json) =>
      _$FaqCategoryFromJson(json);
}

@freezed
abstract class FaqItem with _$FaqItem {
  const factory FaqItem({
    required String question,

    /// 마크다운으로 작성된 사전 답변.
    required String answer,
  }) = _FaqItem;

  factory FaqItem.fromJson(Map<String, dynamic> json) =>
      _$FaqItemFromJson(json);
}
