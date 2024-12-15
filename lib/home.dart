import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notabox/app_theme.dart';
import 'package:notabox/auth/user_provider.dart';
import 'package:notabox/tabs/settings/settings_provider.dart';
import 'package:notabox/tabs/settings/settings_tab.dart';
import 'package:notabox/tabs/tasks/add_task_bottom_sheet.dart';
import 'package:notabox/tabs/tasks/tasks_provider.dart';
import 'package:notabox/tabs/tasks/tasks_tap.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  List<Widget> tabs = [const TasksTap(), const SettingsTab()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.currentUser != null) {
        final userId = userProvider.currentUser!.id;
        Provider.of<TasksProvider>(context, listen: false)
            .getTasks(userId, context); // تمرير الـ context
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User is not logged in or currentUser is null."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                Provider.of<SettingsProvider>(context).backgroundImagePath),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          body: tabs[currentTabIndex],
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10.h,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: AppTheme.white,
            child: BottomNavigationBar(
              currentIndex: currentTabIndex,
              onTap: (index) {
                setState(() {
                  currentTabIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.tasks,
                  icon: Icon(
                    Icons.list,
                    size: 32.sp,
                  ),
                ),
                BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.settings,
                  icon: Icon(Icons.settings_outlined, size: 32.sp),
                ),
              ],
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const AddTaskBottomSheet(),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 60.w,
              width: 60.w,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32.w,
                ),
              ),
            ),
          ),

// تحديد موقع الزر في أسفل الشاشة
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
