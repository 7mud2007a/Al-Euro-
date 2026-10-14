import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../providers/app_state.dart';
import 'auth_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _showLanguagePicker = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      final state = context.read<AppState>();
      if (!state.hasCompletedFirstLaunch) {
        setState(() => _showLanguagePicker = true);
      } else {
        _navigateNext();
      }
    });
  }

  void _navigateNext() {
    final state = context.read<AppState>();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => state.isAuthenticated ? const MainShell() : const AuthScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlEuroColors.charcoal,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: _showLanguagePicker
                ? _buildFirstLaunchLanguageSelector(context)
                : FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                            decoration: BoxDecoration(
                              color: AlEuroColors.black,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AlEuroColors.warmGray, width: 1.2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.directions_car_filled_outlined,
                                  size: 54,
                                  color: AlEuroColors.ivory,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'AL EURO | اليورو',
                                  style: TextStyle(
                                    color: AlEuroColors.ivory,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 60,
                                  height: 3,
                                  color: AlEuroColors.burgundy,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            context.tr('app_subtitle'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AlEuroColors.warmGray, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstLaunchLanguageSelector(BuildContext context) {
    final state = context.watch<AppState>();
    return Card(
      color: AlEuroColors.black,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, color: AlEuroColors.ivory, size: 42),
            const SizedBox(height: 12),
            const Text(
              'اختر لغة التطبيق / Select Language',
              style: TextStyle(color: AlEuroColors.ivory, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _langOptionTile(
              title: 'العربية (Arabic - RTL)',
              subtitle: 'تخطيط عربي كامل بخط تجوال الفاخر',
              isSelected: state.locale.languageCode == 'ar',
              onTap: () => state.setLanguage('ar'),
            ),
            const SizedBox(height: 12),
            _langOptionTile(
              title: 'English (LTR)',
              subtitle: 'Full English interface with Montserrat font',
              isSelected: state.locale.languageCode == 'en',
              onTap: () => state.setLanguage('en'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await state.setLanguage(state.locale.languageCode);
                _navigateNext();
              },
              child: Text(context.tr('continue_btn')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _langOptionTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AlEuroColors.charcoal,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AlEuroColors.burgundy : AlEuroColors.darkGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AlEuroColors.burgundy : AlEuroColors.warmGray,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AlEuroColors.ivory, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AlEuroColors.warmGray, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
