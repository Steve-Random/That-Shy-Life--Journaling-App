import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_widgets.dart';
import 'JournalService.dart';
import 'JournalFeedScreen.dart';
import 'RegisterScreen.dart';
import 'LegalScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await JournalService.login(
        _emailController.text.trim(),
        _passwordController.text,
    );

    if(success){
      if(mounted){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: ((context) => const JournalFeedScreen())),
        );
      }
    }else{
      setState(() {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
      });
    }
  }


  @override
  Widget build( BuildContext context){
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgets.screenTitle(
                  title: 'That Shy Life',
                  subtitle: 'Welcome back',
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

              const SizedBox(height: 8),
              AppWidgets.errorText(_errorMessage),

              const SizedBox(height: 16),
              AppWidgets.primaryButton(
                label: 'Login',
                onPressed: _login,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 16),
              AppWidgets.textLink(
                  label: "Don't have an account? Sign up",
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                        );
                  },
              ),

              const SizedBox(height: 8),
              AppWidgets.textLink(
                label: 'Privacy Policy & Terms of Service',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LegalScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}