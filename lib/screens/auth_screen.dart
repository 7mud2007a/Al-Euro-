import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../providers/app_state.dart';
import 'main_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  bool _otpSent = false;
  String? _errorText;

  void _handlePrimaryAction() {
    setState(() => _errorText = null);
    if (!_otpSent) {
      if (_phoneCtrl.text.trim().length < 8) {
        setState(() => _errorText = context.tr('invalid_phone'));
        return;
      }
      setState(() => _otpSent = true);
    } else {
      if (_otpCtrl.text.trim().length < 4) {
        setState(() => _errorText = context.tr('invalid_otp'));
        return;
      }
      context.read<AppState>().completeLogin();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('app_name')),
        actions: [
          TextButton.icon(
            onPressed: () => state.setLanguage(context.isAr ? 'en' : 'ar'),
            icon: const Icon(Icons.language, color: AlEuroColors.ivory, size: 18),
            label: Text(
              context.isAr ? 'EN' : 'عربي',
              style: const TextStyle(color: AlEuroColors.ivory, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _otpSent ? context.tr('otp_title') : context.tr('login_title'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _otpSent ? context.tr('otp_subtitle') : context.tr('login_subtitle'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  if (!_otpSent)
                    TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: context.tr('phone_label'),
                        hintText: context.tr('phone_hint'),
                        prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AlEuroColors.warmGray),
                      ),
                    )
                  else
                    TextField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, letterSpacing: 12, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: '• • • •',
                        counterText: '',
                      ),
                    ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handlePrimaryAction,
                    child: Text(_otpSent ? context.tr('verify_btn') : context.tr('send_otp')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
