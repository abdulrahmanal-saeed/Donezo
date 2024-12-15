import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notabox/app_theme.dart';
import 'package:notabox/auth/login_screen.dart';
import 'package:notabox/auth/register_screen.dart';
import 'package:notabox/home.dart';
import 'package:notabox/tabs/tasks/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'auth/user_provider.dart';
import 'tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and handle potential errors
  try {
    await Firebase.initializeApp();
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Failed to initialize Firebase: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => TasksProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return ScreenUtilInit(
      designSize:
          const Size(375, 812), // التصميم الأصلي للشاشة (المقاس الأساسي)
      builder: (_, child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(settingsProvider.language),
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          LoginPage.routeName: (_) => const LoginPage(),
          RegisterPage.routeName: (_) => const RegisterPage(),
        },
        initialRoute: LoginPage.routeName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: settingsProvider.themeMode,
      ),
    );
  }
}
