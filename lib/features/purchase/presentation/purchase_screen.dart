import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/theme/color_scheme.dart';
import '../application/purchase_notifier.dart';
import '../data/purchase_product.dart';

class PurchaseScreen extends ConsumerWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PurchaseState>(purchaseNotifierProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
        ref.read(purchaseNotifierProvider.notifier).clearError();
      }
      if (next.lastSuccessProductId != null &&
          next.lastSuccessProductId != prev?.lastSuccessProductId) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('구독이 활성화되었어요. 감사합니다.')));
        ref.read(purchaseNotifierProvider.notifier).clearLastSuccess();
      }
    });

    final state = ref.watch(purchaseNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('이용권 구독')),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : !state.storeAvailable
            ? const _StoreUnavailable()
            : _PlanList(state: state),
      ),
    );
  }
}

class _StoreUnavailable extends StatelessWidget {
  const _StoreUnavailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'Play 결제를 사용할 수 없어요.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Google Play 가 설치된 안드로이드 기기에서만 결제할 수 있어요.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanList extends ConsumerWidget {
  const _PlanList({required this.state});
  final PurchaseState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Play 가 아직 상품을 안 내려줘도(상품 등록 전) 카탈로그는 카드로 보여준다.
    // 그 경우 가격이 없고 "곧 출시" 안내.
    final byId = {for (final p in state.products) p.id: p};

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const _Header(),
        const SizedBox(height: 16),
        for (final p in kPurchaseCatalog) ...[
          _PlanCard(
            product: p,
            playProduct: byId[p.productId],
            isPurchasing: state.activePurchaseId == p.productId,
            disabled:
                state.activePurchaseId != null &&
                state.activePurchaseId != p.productId,
            onBuy: () {
              final play = byId[p.productId];
              if (play == null) return;
              ref.read(purchaseNotifierProvider.notifier).buy(play);
            },
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        const _LegalNotice(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      height: 1.3,
      color: inkColor(context),
      letterSpacing: -0.4,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('학폭위 절차를', style: headline),
        Text('편하게 알아보세요.', style: headline),
        const SizedBox(height: 8),
        Text(
          '이용권으로 일일 한도를 늘릴 수 있어요. 언제든 해지 가능해요.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.product,
    required this.playProduct,
    required this.isPurchasing,
    required this.disabled,
    required this.onBuy,
  });

  final PurchaseProduct product;
  final ProductDetails? playProduct;
  final bool isPurchasing;
  final bool disabled;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final priceText = playProduct?.price ?? '곧 출시 예정';
    final available = playProduct != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.label,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: inkColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: scheme.outline),
                      ),
                    ],
                  ),
                ),
                Text(
                  priceText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: !available || disabled || isPurchasing ? null : onBuy,
              child: isPurchasing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(available ? '구독하기' : '준비 중'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalNotice extends StatelessWidget {
  const _LegalNotice();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      '구독은 Google Play 를 통해 처리되며 영수증 검증 후 이용권이 활성화돼요. '
      '구독 해지·환불은 Play 스토어 → 결제 및 구독에서 처리하실 수 있어요.',
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: scheme.outline, height: 1.5),
    );
  }
}
