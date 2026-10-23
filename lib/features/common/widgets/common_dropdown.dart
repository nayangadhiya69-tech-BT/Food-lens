import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Dropdown in the app's input style (surface fill, 12-radius outline,
/// brand highlight on open) — the select counterpart of
/// `CommonTextField`.
///
/// ```dart
/// CommonDropdown<String>(
///   value: selected,
///   hint: l10n.selectOption,
///   items: const [
///     DropdownItem(value: 'a', label: 'Option A'),
///     DropdownItem(value: 'b', label: 'Option B'),
///   ],
///   onChanged: (v) => setState(() => selected = v),
/// )
/// ```
class CommonDropdown<T> extends StatelessWidget {
  final List<DropdownItem<T>> items;

  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? hint;
  final String? label;
  final String? Function(T?)? validator;
  final bool enabled;
  const CommonDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.label,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label!, style: Theme.of(context).textTheme.labelLarge),
          ),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          hint: hint == null ? null : Text(hint!),
          validator: validator,
          onChanged: enabled ? onChanged : null,
          items: [
            for (final item in items)
              DropdownMenuItem<T>(
                value: item.value,
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColors.line, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColors.line, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColors.brand, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple value/label pair for [CommonDropdown] items.
class DropdownItem<T> {
  final T value;

  final String label;
  const DropdownItem({required this.value, required this.label});
}
