// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'law_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LawArticle _$LawArticleFromJson(Map<String, dynamic> json) => _LawArticle(
  lawName: json['law_name'] as String,
  articleNo: json['article_no'] as String,
  title: json['title'] as String?,
  docType: json['doc_type'] as String,
  content: json['content'] as String,
  effectiveDate: json['effective_date'] as String?,
  sourceUrl: json['source_url'] as String?,
);

Map<String, dynamic> _$LawArticleToJson(_LawArticle instance) =>
    <String, dynamic>{
      'law_name': instance.lawName,
      'article_no': instance.articleNo,
      'title': instance.title,
      'doc_type': instance.docType,
      'content': instance.content,
      'effective_date': instance.effectiveDate,
      'source_url': instance.sourceUrl,
    };
