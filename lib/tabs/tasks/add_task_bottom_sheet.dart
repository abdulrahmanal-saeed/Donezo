import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:notabox/app_theme.dart';
import 'package:notabox/auth/user_provider.dart';
import 'package:notabox/firebase_funcations.dart';
import 'package:notabox/models/task_model.dart';
import 'package:notabox/tabs/settings/settings_provider.dart';
import 'package:notabox/tabs/tasks/default_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Slide من الأسفل
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<SettingsProvider>(context).isDark;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _controller,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.r,
                  spreadRadius: 5.r,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                _buildHeader(isDarkMode),
                SizedBox(height: 15.h),
                Form(key: formKey, child: _buildForm(isDarkMode)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.addNewTask,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool isDarkMode) {
    return Column(
      children: [
        _buildTextField(
          controller: titleController,
          label: AppLocalizations.of(context)!.taskTitle,
          hint: AppLocalizations.of(context)!.placeholder_title,
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: descriptionController,
          label: AppLocalizations.of(context)!.taskDesc,
          hint: AppLocalizations.of(context)!.placeholder_description,
          maxLines: 4,
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: 20.h),
        _buildDatePicker(isDarkMode),
        SizedBox(height: 24.h),
        DefaultElevatedButton(
          label: AppLocalizations.of(context)!.save_task,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              addTask();
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    required bool isDarkMode,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
          fontSize: 12.sp,
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor:
            isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : const Color(0xFF6C63FF),
            width: 1.5.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: const Color(0xFF6C63FF),
            width: 2.w,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.date,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              setState(() => selectedDate = pickedDate);
            }
          },
          child: Text(
            DateFormat('MM/dd/yyyy').format(selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppTheme.primaryLight,
            ),
          ),
        ),
      ],
    );
  }

  void addTask() {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    FirebaseFuncations.addTaskFirestore(
      TaskModel(
        title: titleController.text,
        decerption: descriptionController.text,
        date: selectedDate,
        isDone: false,
        dateAdded: DateTime.now(),
      ),
      userId,
      context,
    ).then((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task Added Successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something Went Wrong!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
