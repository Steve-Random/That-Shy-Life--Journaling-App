import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/app_theme.dart';

/// Shared, pre-styled widgets used across the app's screens, keeping
/// visual consistency (colors, spacing, shapes) in one place rather
/// than duplicated per screen.
///
/// All widgets here automatically follow [AppTheme]'s current light/
/// dark colors.
class AppWidgets {

  //Reusable styled Text Field
 /// A styled text input with a rounded outline border that highlights
  /// with [AppTheme.primary] when focused.
  static Widget textField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }

  //Reusable Primary Button
  /// A full-width elevated button in [AppTheme.primary], showing a
  /// spinner in place of its label while [isLoading] is true.
  static Widget primaryButton({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            )
        ),

        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  //Reusable card container
  static Widget card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
}) {
    return Container(
      width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: AppTheme.surface,
            borderRadius: BorderRadiusGeometry.circular(16),
            border: Border.all(color: AppTheme.border),
        ),
      child: child,
        );
  }


  //Reusable screen title
  static Widget screenTitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
       style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
        letterSpacing: 0.5,
      ),
    ),

    const SizedBox(height: 8),
    Text(
      subtitle,
      style: TextStyle(
        fontSize: 16,
        color: AppTheme.textMuted,
      ),
    ),
    ],
    );
  }

  //Reusable text button link
 static Widget textLink({
    required String label,
   required VoidCallback onPressed,
}) {
    return Center(
      child: TextButton(
          onPressed: onPressed,
          child: Text(label,
          style: TextStyle(color: AppTheme.primary),
          ),
      ),
    );
 }

 //Reusable error message
  ///A red error message or nothing at all if [message] is null
static Widget errorText( String? message) {
    if(message == null) return const SizedBox.shrink();
    return Text(
      message,
      style: const TextStyle(color: Colors.red, fontSize: 13),
    );
}

}

