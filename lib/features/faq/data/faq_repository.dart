import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'faq_dto.dart';

final faqIndexProvider = FutureProvider<FaqIndex>((ref) async {
  final raw = await rootBundle.loadString('assets/faq/faq_seed.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return FaqIndex.fromJson(json);
});
