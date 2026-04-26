/// 백엔드 `chunk.law` 의 사람 읽기용 문자열을 `/laws` API 인자로 분해.
///
/// 입력 예:
/// - `"학폭예방법 제17조 제1항"` → (lawName: "학폭예방법", articleNo: "제17조", paragraph: "제1항")
/// - `"학폭예방법 시행령 제22조"` → (lawName: "학폭예방법 시행령", articleNo: "제22조", paragraph: null)
/// - `"학교폭력예방 및 대책에 관한 법률 제17조의2"` → 조의2 패턴도 인식
class CitationRef {
  const CitationRef({
    required this.lawName,
    required this.articleNo,
    this.paragraph,
  });

  final String lawName;
  final String articleNo;
  final String? paragraph;
}

class CitationParser {
  const CitationParser._();

  static final RegExp _re = RegExp(
    r'^(.+?)\s+(제\d+조(?:의\d+)?)(?:\s+(제\d+항))?(?:\s+제\d+호)?$',
  );

  /// 매치 실패 시 null. 호출 측은 조회 불가 상태로 표시한다.
  static CitationRef? parse(String label) {
    final m = _re.firstMatch(label.trim());
    if (m == null) return null;
    return CitationRef(
      lawName: m.group(1)!.trim(),
      articleNo: m.group(2)!,
      paragraph: m.group(3),
    );
  }
}
