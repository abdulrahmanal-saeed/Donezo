import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notabox/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(1.sw, 52.h), // استخدام ScreenUtil للعرض والارتفاع
        backgroundColor: AppTheme.primaryLight, // اللون الأساسي للزر
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r), // حواف ناعمة
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp, // حجم النص متجاوب
                color: AppTheme.white,
              ),
        ),
      ),
    );
  }
}
