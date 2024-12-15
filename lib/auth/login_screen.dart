import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notabox/auth/register_screen.dart';
import 'package:notabox/auth/user_provider.dart';
import 'package:notabox/firebase_funcations.dart';
import 'package:notabox/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<String?> _emailError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _passwordError = ValueNotifier<String?>(null);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  void _validateEmail() {
    _emailError.value = emailController.text.isNotEmpty
        ? null
        : AppLocalizations.of(context)!.emailEmpty;
  }

  void _validatePassword() {
    _passwordError.value = passwordController.text.isNotEmpty
        ? null
        : AppLocalizations.of(context)!.passwordEmpty;
  }

  Future<void> _login() async {
    _validateEmail();
    _validatePassword();

    if (_emailError.value == null && _passwordError.value == null) {
      setState(() => _isLoading = true);

      try {
        final user = await FirebaseFuncations.login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );

        setState(() => _isLoading = false);

        Provider.of<UserProvider>(context, listen: false).updateUser(user);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } catch (e) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.sometingWrong,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFf8f4ea),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    // Logo
                    Image.asset(
                      'assets/logo/donezo_logo_no_bg.png',
                      height: 216.h, // تقليل الحجم بنسبة 20%
                    ),
                    Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF42446E),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Email Field
                    _buildAnimatedTextField(
                      controller: emailController,
                      label: AppLocalizations.of(context)!.email,
                      icon: Icons.email,
                      isPassword: false,
                      errorNotifier: _emailError,
                    ),
                    SizedBox(height: 15.h),
                    // Password Field
                    _buildPasswordField(
                      controller: passwordController,
                      label: AppLocalizations.of(context)!.password,
                      errorNotifier: _passwordError,
                      isPasswordVisible: _isPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 25.h),
                    // Login Button
                    _buildAnimatedButton(
                      text: _isLoading
                          ? AppLocalizations.of(context)!.loggingIn
                          : AppLocalizations.of(context)!.signin,
                      onPressed: _isLoading ? null : _login,
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterPage.routeName);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.donthaveaccount,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600, // زيادة سمك النص
                          color: const Color(0xFF8C7DF4), // لون بنفسجي أفتح
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityToggle,
    required ValueNotifier<String?> errorNotifier,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier,
      builder: (context, error, child) {
        return TextField(
          controller: controller,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: label,
            errorText: error,
            prefixIcon: const Icon(Icons.lock, color: Color(0xFFB3A9F3)),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onVisibilityToggle,
            ),
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.w),
              borderRadius: BorderRadius.circular(15.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xFF6C63FF), width: 2.w),
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
    required ValueNotifier<String?> errorNotifier,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier,
      builder: (context, error, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: label,
              errorText: error,
              prefixIcon: Icon(icon, color: const Color(0xFFB3A9F3)),
              filled: true,
              fillColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.w),
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0xFF6C63FF), width: 2.w),
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A50E0), // لون بنفسجي أغمق
          elevation: 4, // تأثير الرفع عند الضغط
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          minimumSize: Size(double.infinity, 50.h),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
