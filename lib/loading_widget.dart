import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/gif/donezo_loading.gif',
        height: 200.h, // يمكنك تعديل الحجم حسب الحاجة
        width: 200.w, // يمكنك تعديل الحجم حسب الحاجة
        fit: BoxFit.contain,
      ),
    );
  }
}
