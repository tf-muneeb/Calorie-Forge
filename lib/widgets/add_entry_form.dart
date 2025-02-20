import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class AddEntryForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<AddEntryField> fields;
  final Widget? dropdownField;
  final String submitLabel;
  final IconData submitIcon;
  final VoidCallback onSubmit;
  final Color accentColor;

  const AddEntryForm({
    super.key,
    required this.formKey,
    required this.fields,
    this.dropdownField,
    required this.submitLabel,
    this.submitIcon = Icons.add_rounded,
    required this.onSubmit,
    this.accentColor = const Color(0xFF22C55E),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...fields.map((field) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTextField(field, colors),
          )),
          if (dropdownField != null) ...[
            dropdownField!,
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(submitIcon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    submitLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(AddEntryField field, AppColors colors) {
    return TextFormField(
      controller: field.controller,
      keyboardType: field.keyboardType,
      inputFormatters: field.inputFormatters,
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.hint,
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 13,
        ),
        hintStyle: TextStyle(
          color: colors.textTertiary,
          fontSize: 13,
        ),
        prefixIcon: field.prefixIcon != null
            ? Icon(
          field.prefixIcon,
          color: colors.iconDefault,
          size: 18,
        )
            : null,
        suffixText: field.suffixText,
        suffixStyle: TextStyle(
          color: colors.textTertiary,
          fontSize: 12,
        ),
        filled: true,
        fillColor: colors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.warning),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.warning, width: 1.5),
        ),
        errorStyle: TextStyle(
          color: colors.warning,
          fontSize: 11,
        ),
      ),
      validator: field.validator,
    );
  }
}

class AddEntryField {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final String? suffixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  AddEntryField({
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });
}

class StyledDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;
  final IconData? prefixIcon;

  const StyledDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, color: colors.iconDefault, size: 18),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    items: items,
                    onChanged: onChanged,
                    isExpanded: true,
                    dropdownColor: colors.card,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 14,
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colors.iconDefault,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}