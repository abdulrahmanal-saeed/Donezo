import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notabox/tabs/settings/settings_provider.dart';
import 'package:provider/provider.dart';

class DefaultTextFormField extends StatelessWidget {
  const DefaultTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  }) : assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.');

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);

    final isDark = settingsProvider.isDark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade600,
          fontSize: 14.sp,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: isDark ? Colors.blueAccent : Colors.blue,
            width: 2.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.w,
          ),
        ),
      ),
    );
  }
}
