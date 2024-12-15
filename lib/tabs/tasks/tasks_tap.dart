import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notabox/app_theme.dart';
import 'package:notabox/auth/user_provider.dart';
import 'package:notabox/tabs/settings/settings_provider.dart';
import 'package:notabox/tabs/tasks/task_item.dart';
import 'package:notabox/tabs/tasks/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksTap extends StatefulWidget {
  const TasksTap({super.key});

  @override
  State<TasksTap> createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap>
    with SingleTickerProviderStateMixin {
  bool shouldGetTasks = true;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // استدعاء getTasks مرة واحدة عند بدء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          Provider.of<UserProvider>(context, listen: false).currentUser!.id;
      Provider.of<TasksProvider>(context, listen: false)
          .getTasks(userId, context);
    });

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Slide from bottom to top
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Cleanup animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        backgroundColor:
            settingsProvider.isDark ? Colors.black87 : AppTheme.backgroundLight,
        body: Stack(
          children: [
            // AppBar section
            Positioned(
              top: 0.h,
              left: 0.w,
              right: 0.w,
              child: AppBar(
                backgroundColor: AppTheme.primaryDark,
                title: Padding(
                  padding:
                      EdgeInsetsDirectional.only(start: 20.w, bottom: 49.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.appname,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: settingsProvider.isDark
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        AppLocalizations.of(context)!.below_app_name,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                toolbarHeight: MediaQuery.of(context).size.height * 0.16,
              ),
            ),

            // Date timeline
            Positioned(
              top: 111.h,
              left: 0.w,
              right: 0.w,
              child: EasyInfiniteDateTimeLine(
                selectionMode: const SelectionMode.autoCenter(),
                firstDate: DateTime.now().subtract(const Duration(days: 18250)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(const Duration(days: 18250)),
                showTimelineHeader: false,
                onDateChange: (selectedDate) {
                  tasksProvider.changeSelectedDate(selectedDate);

                  final userId =
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser!
                          .id;
                  tasksProvider.getTasks(userId, context);
                },
                dayProps: EasyDayProps(
                  todayHighlightStyle: TodayHighlightStyle.withBackground,
                  todayHighlightColor: AppTheme.primaryLight,
                  dayStructure: DayStructure.dayStrDayNumMonth,
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? Colors.grey[850]
                          : Colors.grey[200],
                      border: Border.all(
                        color: settingsProvider.isDark
                            ? Colors.white54
                            : Colors.grey,
                        width: 1.r,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: settingsProvider.isDark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.white, width: 1.w),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                locale: settingsProvider.language,
              ),
            ),

            // Task list or empty state
            Positioned.fill(
              top: 180.h,
              child: tasksProvider.tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/empty_notes.json',
                            height: 200.h,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            AppLocalizations.of(context)!.tasksYet,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: settingsProvider.isDark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(height: 40.h),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (_, index) =>
                                TaskItem(tasksProvider.tasks[index]),
                            itemCount: tasksProvider.tasks.length,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
