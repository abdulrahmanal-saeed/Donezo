import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notabox/auth/user_provider.dart';
import 'package:notabox/firebase_funcations.dart';
import 'package:notabox/models/task_model.dart';
import 'package:notabox/tabs/settings/settings_provider.dart';
import 'package:notabox/tabs/tasks/edit_task_page.dart';
import 'package:notabox/tabs/tasks/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_theme.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});
  final TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool isDone;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isDone = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                _buildSlidableAction(
                  color: AppTheme.red,
                  icon: Icons.delete,
                  label: AppLocalizations.of(context)!.delete,
                  borderRadius: isArabic
                      ? const BorderRadius.only(
                          bottomRight: Radius.circular(0),
                          topRight: Radius.circular(0))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                  onTap: () => _deleteTask(context),
                ),
                _buildSlidableAction(
                  color: AppTheme.primaryDark,
                  icon: Icons.edit,
                  label: AppLocalizations.of(context)!.edit,
                  borderRadius: isArabic
                      ? const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15))
                      : const BorderRadius.only(
                          bottomRight: Radius.circular(0),
                          topRight: Radius.circular(0)),
                  onTap: () => _editTask(context),
                ),
              ],
            ),
            child: _buildTaskContainer(themeData, isDarkMode, isArabic),
          ),
        ),
      ],
    );
  }

  /// Builds SlidableAction
  SlidableAction _buildSlidableAction({
    required Color color,
    required IconData icon,
    required String label,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    return SlidableAction(
      onPressed: (_) => onTap(),
      backgroundColor: color,
      foregroundColor: AppTheme.white,
      icon: icon,
      label: label,
      borderRadius: borderRadius,
    );
  }

  /// Builds the Task Container with shadow for depth
  Widget _buildTaskContainer(
      ThemeData themeData, bool isDarkMode, bool isArabic) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: isArabic
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(15), topLeft: Radius.circular(15))
            : const BorderRadius.only(
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // ظل خفيف لعمق أفضل
            blurRadius: 10.r,
            spreadRadius: 2.r,
            offset: Offset(0, 4.h),
          ),
        ],
        border: Border.all(
          color: isDone ? Colors.green : Colors.blueAccent,
          width: isDone ? 2.r : 1.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTaskIndicator(),
          Expanded(
            child: _buildTaskContent(themeData, isDarkMode),
          ),
          SizedBox(width: 16.w),
          _buildTaskStatusToggle(),
        ],
      ),
    );
  }

  /// Task status indicator (left line)
  Widget _buildTaskIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 4.w,
      height: 60.h,
      margin: EdgeInsetsDirectional.only(end: 16.w),
      color: isDone ? Colors.green : Colors.blueAccent,
    );
  }

  /// Improved Task content with better spacing and alignment
  Widget _buildTaskContent(ThemeData themeData, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: themeData.textTheme.titleMedium!.copyWith(
            color: isDone ? Colors.green : Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp, // زيادة حجم النص
          ),
          child: Text(widget.task.title),
        ),
        SizedBox(height: 6.h),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isDone ? 0.6 : 1.0,
          child: Text(
            widget.task.decerption,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
              fontSize: 15.sp, // تحسين حجم النص
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Task status toggle button with shadow
  Widget _buildTaskStatusToggle() {
    return GestureDetector(
      onTap: () => _toggleTaskStatus(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Container(
          key: ValueKey(isDone),
          height: 45.r,
          width: 45.r,
          decoration: BoxDecoration(
            color: isDone ? Colors.green : Colors.blueAccent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Icon(
            isDone ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
            size: 28.sp, // زيادة حجم الأيقونة
          ),
        ),
      ),
    );
  }

  /// Handles deleting task
  Future<void> _deleteTask(BuildContext context) async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    setState(() => isLoading = true);

    await FirebaseFuncations.deleteTaskFirestore(
            widget.task.id, userId, context)
        .then((_) {
      Provider.of<TasksProvider>(context, listen: false)
          .getTasks(userId, context);
    }).catchError((_) {
      Fluttertoast.showToast(
          msg: "Something Went Wrong!", backgroundColor: Colors.red);
    }).whenComplete(() => setState(() => isLoading = false));
  }

  /// Handles toggling task status
  void _toggleTaskStatus() {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    setState(() {
      isDone = !isDone;
    });

    FirebaseFuncations.updateTaskStatus(
        widget.task.id, userId, isDone, context);
  }

  /// Navigates to Edit Task Page
  void _editTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditTaskPage(task: widget.task)),
    );
  }
}
