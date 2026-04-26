import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/app_database.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../data/inbox_repository.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _tab = 0;
  static const _tabs = ['전체', '진행', '일정', '가이드'];
  static const _kinds = ['', 'milestone', 'event', 'guide'];

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(inboxRepositoryProvider);
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      appBar: AppBar(
        backgroundColor: AppTokens.lBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppTokens.lInk,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text(
          '알림',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppTokens.lInk,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: repo.markAllRead,
            child: const Text(
              '모두 읽음',
              style: TextStyle(
                fontSize: 12,
                color: AppTokens.lSub,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _TabRow(
              tabs: _tabs,
              current: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
            Expanded(
              child: StreamBuilder<List<InboxRow>>(
                stream: repo.watchAll(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final all = snap.data ?? const [];
                  final filterKind = _kinds[_tab];
                  final list = filterKind.isEmpty
                      ? all
                      : all.where((it) => it.kind == filterKind).toList();
                  if (list.isEmpty) {
                    return const _EmptyView();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final it = list[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i == list.length - 1 ? 0 : 8,
                        ),
                        child: _NotiCard(
                          item: it,
                          onTap: () => repo.markRead(it.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({
    required this.tabs,
    required this.current,
    required this.onTap,
  });
  final List<String> tabs;
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                color: i == current ? AppTokens.lPrimary : AppTokens.lCard,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onTap(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: i == current
                            ? AppTokens.lPrimary
                            : AppTokens.lLine,
                      ),
                    ),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: i == current ? Colors.white : AppTokens.lInk,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotiCard extends StatelessWidget {
  const _NotiCard({required this.item, required this.onTap});
  final InboxRow item;
  final VoidCallback onTap;

  ({Color bg, Color fg, IconData icon}) _tone() => switch (item.kind) {
    'milestone' => (
      bg: AppTokens.lTileTint,
      fg: AppTokens.lPrimary,
      icon: Icons.check_rounded,
    ),
    'event' => (
      bg: const Color(0xFFFAEAD0),
      fg: AppTokens.lAccent,
      icon: Icons.event_outlined,
    ),
    'guide' => (
      bg: const Color(0xFFF1ECE2),
      fg: const Color(0xFF7A5A2E),
      icon: Icons.menu_book_outlined,
    ),
    _ => (
      bg: AppTokens.lTileTint,
      fg: AppTokens.lPrimary,
      icon: Icons.notifications_none,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final t = _tone();
    return Material(
      color: AppTokens.lCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: AppTokens.lCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTokens.lLine),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: t.bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(t.icon, size: 16, color: t.fg),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: item.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: AppTokens.lInk,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTokens.lPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (item.detail.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.detail,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppTokens.lSub,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      _formatRelative(item.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTokens.lSub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 56,
              color: AppTokens.lSub,
            ),
            const SizedBox(height: 12),
            const Text(
              '아직 알림이 없어요.',
              style: TextStyle(fontSize: 13.5, color: AppTokens.lInk),
            ),
            const SizedBox(height: 4),
            Text(
              '신고나 사안 진행이 있을 때 여기에 알려드릴게요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: AppTokens.lSub),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatRelative(DateTime when) {
  final now = DateTime.now();
  final d = now.difference(when);
  if (d.inMinutes < 1) return '방금 전';
  if (d.inHours < 1) return '${d.inMinutes}분 전';
  if (d.inDays < 1) return '${d.inHours}시간 전';
  if (d.inDays < 7) return '${d.inDays}일 전';
  return '${when.year % 100}.${when.month}.${when.day}';
}
