import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/LoginScreen.dart';

import 'JournalFeedScreen.dart';
import 'JournalService.dart';
import 'app_theme.dart';
import 'app_widgets.dart';
import 'LegalScreen.dart';
import 'OnboardingScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await JournalService.register(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(
              onDone: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JournalFeedScreen(),
                  ),
                );
              },
            ),
          ),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Email already registered or something went wrong';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppWidgets.screenTitle(
                          title: 'That Shy Life',
                          subtitle: 'Create your account',
                        ),

                        const SizedBox(height: 32),
                        AppWidgets.textField(
                          controller: _emailController,
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),
                        AppWidgets.textField(
                          controller: _passwordController,
                          hint: 'Password',
                          obscure: true,
                        ),

                        const SizedBox(height: 16),
                        AppWidgets.textField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm Password',
                          obscure: true,
                        ),

                        const SizedBox(height: 8),
                        AppWidgets.errorText(_errorMessage),

                        const SizedBox(height: 16),
                        AppWidgets.primaryButton(
                          label: 'Create Account',
                          onPressed: _register,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 16),
                        AppWidgets.textLink(
                          label: "Already have an account? Login",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),
                        AppWidgets.textLink(
                          label: 'Privacy Policy & Terms of Service',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LegalScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
