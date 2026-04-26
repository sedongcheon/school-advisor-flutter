// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FaqIndex _$FaqIndexFromJson(Map<String, dynamic> json) => _FaqIndex(
  version: (json['version'] as num).toInt(),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => FaqCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FaqIndexToJson(_FaqIndex instance) => <String, dynamic>{
  'version': instance.version,
  'categories': instance.categories,
};

_FaqCategory _$FaqCategoryFromJson(Map<String, dynamic> json) => _FaqCategory(
  id: json['id'] as String,
  label: json['label'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FaqCategoryToJson(_FaqCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'items': instance.items,
    };

_FaqItem _$FaqItemFromJson(Map<String, dynamic> json) => _FaqItem(
  question: json['question'] as String,
  answer: json['answer'] as String,
);

Map<String, dynamic> _$FaqItemToJson(_FaqItem instance) => <String, dynamic>{
  'question': instance.question,
  'answer': instance.answer,
};
