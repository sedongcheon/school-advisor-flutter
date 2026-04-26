// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'law_index_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LawIndex _$LawIndexFromJson(Map<String, dynamic> json) => _LawIndex(
  version: (json['version'] as num).toInt(),
  groups: (json['groups'] as List<dynamic>)
      .map((e) => LawGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LawIndexToJson(_LawIndex instance) => <String, dynamic>{
  'version': instance.version,
  'groups': instance.groups,
};

_LawGroup _$LawGroupFromJson(Map<String, dynamic> json) => _LawGroup(
  lawName: json['law_name'] as String,
  shortName: json['short_name'] as String,
  docType: json['doc_type'] as String,
  articles: (json['articles'] as List<dynamic>)
      .map((e) => LawArticleEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LawGroupToJson(_LawGroup instance) => <String, dynamic>{
  'law_name': instance.lawName,
  'short_name': instance.shortName,
  'doc_type': instance.docType,
  'articles': instance.articles,
};

_LawArticleEntry _$LawArticleEntryFromJson(Map<String, dynamic> json) =>
    _LawArticleEntry(
      articleNo: json['article_no'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$LawArticleEntryToJson(_LawArticleEntry instance) =>
    <String, dynamic>{
      'article_no': instance.articleNo,
      'title': instance.title,
    };
