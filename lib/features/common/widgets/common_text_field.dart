import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';

/// Text field in the app's rounded "capsule" container: animated border
/// (line → brand on focus → danger on error), optional `+91`-style prefix
/// with a vertical divider, and a hidden counter.
///
/// Used by the login phone field and the onboarding name field — the
/// rendered UI matches the original screens pixel-for-pixel.
class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.prefix,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.letterSpacing,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;

  /// Optional externally-owned node (lets callers request focus on error).
  final FocusNode? focusNode;
  final String? prefix;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final double? letterSpacing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.errorText != null
        ? AppColors.danger
        : (_focused ? AppColors.brand : AppColors.line);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(14),
            vertical: dynamicHeight(4),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                Text(
                  widget.prefix!,
                  style: AppTextStyle.create(
                    fontSize: 16,
                    weight: FontWeights.bold,
                    color: AppColors.inkSecondary,
                  ),
                ),
                SizedBox(width: dynamicWidth(10)),
                Container(
                  width: dynamicWidth(1),
                  height: dynamicHeight(22),
                  color: AppColors.line,
                ),
                SizedBox(width: dynamicWidth(10)),
              ],
              Expanded(
                child: Focus(
                  onFocusChange: (focused) {
                    if (mounted) setState(() => _focused = focused);
                  },
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    autofillHints: widget.autofillHints,
                    inputFormatters: widget.inputFormatters,
                    maxLength: widget.maxLength,
                    style: AppTextStyle.create(
                      fontSize: 17,
                      color: AppColors.ink,
                      letterSpacing: widget.letterSpacing,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      hintText: widget.hint,
                      hintStyle: const TextStyle(color: AppColors.inkTertiary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: dynamicHeight(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(
              top: dynamicHeight(8),
              left: dynamicWidth(4),
            ),
            child: Text(
              widget.errorText!,
              style: AppTextStyle.create(fontSize: 13, color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}
