import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:notabox/loading_widget.dart';
import 'package:notabox/models/task_model.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../firebase_funcations.dart';
import '../settings/settings_provider.dart';
import 'default_elevated_button.dart';
import 'tasks_provider.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;

  const EditTaskPage({super.key, required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.decerption);
    selectedDate = widget.task.date;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color:
                isDarkMode ? const Color(0xFF121212) : AppTheme.backgroundLight,
          ),
          SlideTransition(
            position: _slideAnimation,
            child: _buildHeader(context, isDarkMode),
          ),
          Positioned.fill(
            top: 100.h,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildEditForm(context, isDarkMode, textTheme),
              ),
            ),
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Container(
      height: 150.h,
      color: AppTheme.primaryLight,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDarkMode ? Colors.black : Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 10.w),
          Text(
            "Edit Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(
      BuildContext context, bool isDarkMode, TextTheme textTheme) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTextField(
              controller: titleController,
              label: "Task Title",
              hint: "Enter task title",
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 20.h),
            _buildTextField(
              controller: descriptionController,
              label: "Task Description",
              hint: "Enter task description",
              maxLines: 4,
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 20.h), // تباعد إضافي تحت التاريخ
            _buildDatePicker(context, textTheme, isDarkMode),
            SizedBox(height: 28.h),
            DefaultElevatedButton(
              label: "Save Changes",
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  updateTask();
                }
              },
            ),
          ],
        ),
      ),
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
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label cannot be empty.";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
        hintText: hint,
        hintStyle:
            TextStyle(color: isDarkMode ? Colors.grey.shade700 : Colors.grey),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: isDarkMode ? Colors.grey : Colors.black),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      BuildContext context, TextTheme textTheme, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Select Date",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16.sp,
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
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Text(
            DateFormat('MM/dd/yyyy').format(selectedDate),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryLight,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  void updateTask() async {
    setState(() => isLoading = true);

    widget.task.title = titleController.text;
    widget.task.decerption = descriptionController.text;
    widget.task.date = selectedDate;

    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    await FirebaseFuncations.updateTaskFirestore(widget.task, userId, context)
        .then((_) {
      Provider.of<TasksProvider>(context, listen: false)
          .getTasks(userId, context);
      Fluttertoast.showToast(
        msg: "Task Updated Successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Error updating task!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }).whenComplete(() {
      setState(() => isLoading = false);
      Navigator.of(context).pop();
    });
  }
}
