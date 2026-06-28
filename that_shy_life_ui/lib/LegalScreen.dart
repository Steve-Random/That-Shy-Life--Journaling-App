import 'package:flutter/material.dart';
import 'app_theme.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Legal'),
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.primary,
          elevation: 1,
          scrolledUnderElevation: 0,
          bottom: TabBar(
            labelColor: AppTheme.primary,
            indicatorColor: AppTheme.primary,
            tabs: const [
              Tab(text: 'Privacy Policy'),
              Tab(text: 'Terms of Service'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPrivacyPolicy(),
            _buildTermsOfService(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heading('Privacy Policy'),
          _sub('Effective Date: June 27, 2026'),
          _body('That Shy Life operates the That Shy Life journaling app. This Privacy Policy explains how we collect, use, and protect your information.'),
          _heading2('Information We Collect'),
          _body('We collect only what is needed to run the app:\n\n• Email address – to identify your account.\n• Password – stored securely and never in plain text.\n• Journal entries – the content and social battery ratings you record.'),
          _heading2('How We Use Your Information'),
          _body('Your data is used solely to provide the app\'s features. We do not use it for advertising or profiling.'),
          _heading2('Analytics'),
          _body('The app uses Firebase Analytics to collect anonymous usage data (e.g. screen views). This does not identify you personally.'),
          _heading2('Data Sharing'),
          _body('We do not sell or share your data. We use Firebase/Google for anonymous analytics only.'),
          _heading2('Data Retention'),
          _body('Your data is retained while your account is active. Contact us to request deletion.'),
          _heading2('Children\'s Privacy'),
          _body('The app is not directed at children under 13. We do not knowingly collect data from children under 13.'),
          _heading2('Contact'),
          _body('stevenaatoo@gmail.com'),
        ],
      ),
    );
  }

  Widget _buildTermsOfService() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heading('Terms of Service'),
          _sub('Effective Date: June 27, 2026'),
          _body('By using That Shy Life, you agree to these Terms.'),
          _heading2('Eligibility'),
          _body('You must be at least 13 years old to use the app.'),
          _heading2('Your Account'),
          _body('You are responsible for keeping your credentials secure. Notify us immediately of any unauthorized access.'),
          _heading2('Acceptable Use'),
          _body('You agree not to use the app for unlawful purposes, attempt to access other users\' data, or reverse engineer the app.'),
          _heading2('Your Content'),
          _body('You own your journal entries. We only store them to provide the service to you.'),
          _heading2('Disclaimer'),
          _body('The app is provided "as is" without warranties. Use it at your own risk.'),
          _heading2('Governing Law'),
          _body('These Terms are governed by the laws of the United States.'),
          _heading2('Contact'),
          _body('stevenaatoo@gmail.com'),
        ],
      ),
    );
  }

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primary)),
  );

  Widget _heading2(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 4),
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
  );

  Widget _sub(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
  );

  Widget _body(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
  );
}