/// 입력창 텍스트에서 PII(개인식별정보)를 정규식으로 탐지.
///
/// **이중 방어**: 백엔드 `sanitize_input` 도 마스킹하지만, 클라이언트는
/// 사용자가 전송 전에 인지·수정할 수 있도록 다이얼로그를 띄운다.
library;

class PiiDetector {
  const PiiDetector._();

  // 주민등록번호: 6-1~4 + 6자리 (구분자 - 또는 공백 또는 없음)
  static final RegExp _ssn = RegExp(r'\b\d{6}[-\s]?[1-4]\d{6}\b');

  // 휴대폰: 010/011/016~019 + 3~4 + 4
  static final RegExp _phone = RegExp(r'\b01[016-9][-\s]?\d{3,4}[-\s]?\d{4}\b');

  // 학교명: ○○초등학교/중학교/고등학교 (실명 추정)
  static final RegExp _school = RegExp(r'[가-힣]{1,10}(초등학교|중학교|고등학교)');

  /// 텍스트에서 PII 가 검출됐는지.
  static PiiScanResult scan(String text) {
    final ssn = _ssn.allMatches(text).map((m) => m.group(0)!).toList();
    final phones = _phone.allMatches(text).map((m) => m.group(0)!).toList();
    final schools = _school.allMatches(text).map((m) => m.group(0)!).toList();
    return PiiScanResult(ssns: ssn, phones: phones, schools: schools);
  }

  /// 입력 텍스트에서 검출된 패턴을 마스킹한 문자열을 반환.
  static String mask(String text) {
    return text
        .replaceAllMapped(_ssn, (_) => '[주민번호]')
        .replaceAllMapped(_phone, (_) => '[전화번호]')
        .replaceAllMapped(_school, (m) => '[학교명${m.group(1) ?? ''}]');
  }
}

class PiiScanResult {
  const PiiScanResult({
    required this.ssns,
    required this.phones,
    required this.schools,
  });

  final List<String> ssns;
  final List<String> phones;
  final List<String> schools;

  bool get hasAny => ssns.isNotEmpty || phones.isNotEmpty || schools.isNotEmpty;

  /// 사용자 노출용 한국어 라벨 목록.
  List<String> get labels => [
    if (ssns.isNotEmpty) '주민등록번호',
    if (phones.isNotEmpty) '휴대폰 번호',
    if (schools.isNotEmpty) '학교명',
  ];
}
