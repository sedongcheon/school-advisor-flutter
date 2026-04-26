/// 구독 상품 카탈로그.
///
/// `productId` 는 Play Console 에 등록된 상품 ID 와 일치해야 한다.
/// `planCode` 는 백엔드 `user_status.plan` 과 매칭.
class PurchaseProduct {
  const PurchaseProduct({
    required this.productId,
    required this.label,
    required this.description,
    required this.planCode,
  });

  final String productId;
  final String label;
  final String description;
  final String planCode;
}

const List<PurchaseProduct> kPurchaseCatalog = [
  PurchaseProduct(
    productId: 'advisor_7day',
    label: '7일권',
    description: '7일 동안 매일 충분한 횟수의 질문',
    planCode: '7day',
  ),
  PurchaseProduct(
    productId: 'advisor_30day',
    label: '30일권',
    description: '한 달 동안 학폭위 절차 전반을 자유롭게',
    planCode: '30day',
  ),
  PurchaseProduct(
    productId: 'advisor_teacher',
    label: '교사 플랜',
    description: '학교 인증 교사용 — 무제한 질문',
    planCode: 'teacher',
  ),
];

const Set<String> kPurchaseProductIds = {
  'advisor_7day',
  'advisor_30day',
  'advisor_teacher',
};
