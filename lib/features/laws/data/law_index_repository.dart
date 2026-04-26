import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'law_index_dto.dart';

/// 자산 JSON 을 한 번만 로드해 메모리에 캐시한다.
final lawIndexProvider = FutureProvider<LawIndex>((ref) async {
  final raw = await rootBundle.loadString('assets/laws/index.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return LawIndex.fromJson(json);
});

/// 검색어로 그룹별 결과를 필터링.
List<LawGroup> filterLawIndex(LawIndex index, String query) {
  final q = query.trim();
  if (q.isEmpty) return index.groups;
  final lower = q.toLowerCase();
  return [
    for (final g in index.groups)
      if (_matchGroup(g, lower))
        g.copyWith(
          articles: [
            for (final a in g.articles)
              if (_matchArticle(g, a, lower)) a,
          ],
        ),
  ].where((g) => g.articles.isNotEmpty).toList();
}

bool _matchGroup(LawGroup g, String lower) {
  return g.lawName.toLowerCase().contains(lower) ||
      g.shortName.toLowerCase().contains(lower) ||
      g.articles.any((a) => _matchArticle(g, a, lower));
}

bool _matchArticle(LawGroup g, LawArticleEntry a, String lower) {
  return a.articleNo.toLowerCase().contains(lower) ||
      a.title.toLowerCase().contains(lower) ||
      g.shortName.toLowerCase().contains(lower) ||
      g.lawName.toLowerCase().contains(lower);
}
