import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';

/// 챗봇 입력 바. 새 디자인 가이드 (rounded composer + primary 전송 버튼).
class InputBar extends StatefulWidget {
  const InputBar({required this.onSubmit, required this.enabled, super.key});

  final ValueChanged<String> onSubmit;
  final bool enabled;

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    if (!_hasText || !widget.enabled) return;
    final text = _controller.text.trim();
    _controller.clear();
    widget.onSubmit(text);
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
          decoration: BoxDecoration(
            color: AppTokens.lCard,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppTokens.lPrimary.withValues(alpha: 0.12),
                offset: const Offset(0, 2),
                blurRadius: 10,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: '메시지를 입력하세요…',
                    hintStyle: TextStyle(
                      color: Color(0xFF9AAA9F),
                      fontSize: 13.5,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Material(
                color: (_hasText && widget.enabled)
                    ? AppTokens.lPrimary
                    : AppTokens.lPrimary.withValues(alpha: 0.4),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: (_hasText && widget.enabled) ? _send : null,
                  child: const SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
