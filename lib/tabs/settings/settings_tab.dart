import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notabox/app_theme.dart';
import 'package:notabox/auth/login_screen.dart';
import 'package:notabox/firebase_funcations.dart';
import 'package:notabox/tabs/settings/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.16,
        backgroundColor:
            isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              _buildInteractiveCard(
                icon: Icons.language,
                title: AppLocalizations.of(context)!.language,
                child: _buildLanguageDropdown(settingsProvider, isDarkMode),
              ),
              SizedBox(height: 20.h),
              _buildInteractiveCard(
                icon: Icons.palette_outlined,
                title: AppLocalizations.of(context)!.mode,
                child: _buildThemeDropdown(settingsProvider, isDarkMode),
              ),
              SizedBox(height: 20.h),
              _buildInteractiveCard(
                icon: Icons.contact_support_outlined,
                title: AppLocalizations.of(context)!.contact_us,
                child: _buildWhatsAppButton(),
              ),
              SizedBox(height: 30.h),
              _buildLogoutButton(isDarkMode),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

// تحسين الأيقونات لجعلها بنفس لون التطبيق
  Widget _buildInteractiveCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 10.h), // إضافة تباعد إضافي
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.white10,
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryDark, // لون أيقونات بنفس لون التطبيق
              size: 30.sp,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(
      SettingsProvider settingsProvider, bool isDarkMode) {
    return _buildDropdown(
      value: settingsProvider.language,
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
      ],
      onChanged: (value) => settingsProvider.changeLanguage(value),
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildThemeDropdown(
      SettingsProvider settingsProvider, bool isDarkMode) {
    return _buildDropdown(
      value: isDarkMode ? 'dark' : 'light',
      items: [
        DropdownMenuItem(
            value: 'light',
            child: Text(
              AppLocalizations.of(context)!.light,
            )),
        DropdownMenuItem(
            value: 'dark', child: Text(AppLocalizations.of(context)!.dark)),
      ],
      onChanged: (value) {
        settingsProvider.changeThemeMode(
            value == 'dark' ? ThemeMode.dark : ThemeMode.light);
      },
      isDarkMode: isDarkMode,
    );
  }

// تحسين Dropdown مع Fade-in عند تبديل اللغة أو الوضع
  Widget _buildDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String> onChanged,
    required bool isDarkMode,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey<String>(value),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: items,
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            isExpanded: true,
            dropdownColor: isDarkMode ? Colors.black87 : Colors.white,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

// تحسين زر واتساب بإضافة ظل
  Widget _buildWhatsAppButton() {
    return ElevatedButton.icon(
      onPressed: _openWhatsApp,
      icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 20.sp),
      label: Text(
        AppLocalizations.of(context)!.chat,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        elevation: 4, // إضافة ظل خفيف
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  void _openWhatsApp() async {
    const String message = "Hello, Can i ask you someting about Donezo App";
    const String phone = "971585829128";
    final String url = "https://wa.me/$phone?text=${Uri.encodeFull(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open WhatsApp')),
      );
    }
  }

  // زر تسجيل الخروج مع نافذة التأكيد
  Widget _buildLogoutButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: GoogleFonts.poppins(
                    fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              content: Text(
                AppLocalizations.of(context)!.logout_confirmation,
                style: GoogleFonts.poppins(fontSize: 14.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldLogout == true) {
          setState(() => isLoading = true);
          await FirebaseFuncations.logout(context);
          setState(() => isLoading = false);
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      child: Text(
        AppLocalizations.of(context)!.logout,
        style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white),
      ),
    );
  }
}
