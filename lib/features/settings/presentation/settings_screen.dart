import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../application/notifications_notifier.dart';
import '../application/theme_mode_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _SectionTitle('알림'),
            const _NotificationsCard(),
            const SizedBox(height: 16),
            _SectionTitle('화면'),
            const _ThemeModeCard(),
            const SizedBox(height: 16),
            _SectionTitle('약관 · 도움말'),
            _LinkCard(
              icon: Icons.gavel_outlined,
              title: '서비스 이용 안내',
              subtitle: '면책 고지 다시 보기',
              onTap: () => context.push(AppRoutes.disclaimer),
            ),
            const SizedBox(height: 8),
            _LinkCard(
              icon: Icons.description_outlined,
              title: '오픈소스 라이선스',
              onTap: () async {
                final info = await PackageInfo.fromPlatform();
                if (!context.mounted) return;
                showLicensePage(
                  context: context,
                  applicationName: '학폭 나침반',
                  applicationVersion: info.version,
                );
              },
            ),
            const SizedBox(height: 16),
            _SectionTitle('앱 정보'),
            const _VersionCard(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.outline,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

class _NotificationsCard extends ConsumerWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(notificationsEnabledProvider);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
        child: Row(
          children: [
            Icon(Icons.notifications_outlined, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '푸시 알림 받기',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: inkColor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '법령 개정·중요 공지를 알림으로 받아요',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: scheme.outline),
                  ),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: (v) async {
                final ok = await ref
                    .read(notificationsEnabledProvider.notifier)
                    .setEnabled(v);
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('알림 권한이 꺼져 있어요. 시스템 설정에서 허용해 주세요.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeCard extends ConsumerWidget {
  const _ThemeModeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeModeProvider);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.brightness_6_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Text(
                  '테마 모드',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: inkColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('시스템')),
                ButtonSegment(value: ThemeMode.light, label: Text('라이트')),
                ButtonSegment(value: ThemeMode.dark, label: Text('다크')),
              ],
              selected: {current},
              onSelectionChanged: (s) =>
                  ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: inkColor(context),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: scheme.outline),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snap) {
          final version = snap.data?.version ?? '-';
          final build = snap.data?.buildNumber ?? '-';
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '학폭 나침반',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: inkColor(context),
                    ),
                  ),
                ),
                Text(
                  'v$version ($build)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
