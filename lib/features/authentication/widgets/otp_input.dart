import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

/// Six-box OTP entry from the HTML design with focus traversal,
/// backspace handling and one-time-code autofill hints.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.onChanged,
    this.length = 6,
  });

  final ValueChanged<String> onChanged;
  final int length;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (i) => TextEditingController()..addListener(_onAnyValueChanged),
    );
    _focusNodes = List.generate(widget.length, (i) {
      final node = FocusNode();
      node.addListener(() {
        if (mounted) setState(() {});
      });
      return node;
    });
  }

  void _onAnyValueChanged() {
    if (mounted) setState(() {});
    widget.onChanged(value);
  }

  String get value => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _handleChanged(int index, String text) {
    if (text.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < widget.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _OtpBox(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              focused: _focusNodes[i].hasFocus,
              autofill: i == 0,
              isLast: i == widget.length - 1,
              onChanged: (text) => _handleChanged(i, text),
            ),
          ],
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.focused,
    required this.autofill,
    required this.isLast,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool focused;
  final bool autofill;
  final bool isLast;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final filled = controller.text.isNotEmpty;
    final color = (focused || filled) ? AppColors.brand : AppColors.line;

    return Container(
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: filled ? AppColors.brandBackground : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: focused ? 2 : 1.5),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        textAlign: TextAlign.center,
        maxLength: 1,
        autofillHints: autofill ? const [AutofillHints.oneTimeCode] : null,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        decoration: const InputDecoration(
          isDense: true,
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
