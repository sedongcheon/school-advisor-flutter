/// FCM 메시지 `data` 페이로드를 도메인 모델로 변환.
///
/// 백엔드가 보낼 기대 페이로드 (예시):
/// - `{"type": "law_article", "law": "학폭예방법", "article_no": "제17조"}`
/// - `{"type": "notice"}`
///
/// 알 수 없는 타입은 [NotificationPayloadOpen] 으로 fallback (홈으로 이동).
sealed class NotificationPayload {
  const NotificationPayload();

  static NotificationPayload? from(Map<String, dynamic> data) {
    final type = data['type'];
    if (type is! String) return null;
    switch (type) {
      case 'law_article':
        final law = data['law'];
        final articleNo = data['article_no'];
        if (law is String && articleNo is String) {
          return NotificationPayloadLawArticle(
            lawName: law,
            articleNo: articleNo,
          );
        }
        return const NotificationPayloadOpen();
      case 'notice':
        return const NotificationPayloadOpen();
      default:
        return const NotificationPayloadOpen();
    }
  }
}

class NotificationPayloadLawArticle extends NotificationPayload {
  const NotificationPayloadLawArticle({
    required this.lawName,
    required this.articleNo,
  });
  final String lawName;
  final String articleNo;
}

class NotificationPayloadOpen extends NotificationPayload {
  const NotificationPayloadOpen();
}
