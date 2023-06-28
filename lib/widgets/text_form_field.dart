
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obsecureText;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final bool autofocus;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final FocusNode? focusNode;

  final EdgeInsets? margin;

  const AppTextFormField({
    super.key,
    required this.label,
    this.focusNode,
    this.obsecureText = false,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.enabled,
    this.minLines = 1,
    this.maxLines = 1,
    this.autofocus = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        obscureText: obsecureText,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        minLines: minLines,
        maxLines: maxLines,
        autofocus: autofocus,
        decoration: InputDecoration(
          label: Text(label),
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
    
        enabled: enabled,
      ),
    );
  }
}