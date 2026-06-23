import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'JournalService.dart';
import 'JournalFeedScreen.dart';
import 'RegisterScreen.dart';

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
              Text(
                'That Shy Life',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: 0.5
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textMuted,
                ),
              ),

              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                  keyboardType:TextInputType.emailAddress,
                style: TextStyle(color: AppTheme.textDark),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: AppTheme.textMuted),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.surface,
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: AppTheme.textDark),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: AppTheme.textMuted),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.surface,
                ),
              ),

              const SizedBox(height: 8),
              if(_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _isLoading?null: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      )
                    ),

                    child: _isLoading
                      ?const CircularProgressIndicator(color: Colors.white)
                      :const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const RegisterScreen())),
                          );
                    },

                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: AppTheme.primary),
                    ),
                ),
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