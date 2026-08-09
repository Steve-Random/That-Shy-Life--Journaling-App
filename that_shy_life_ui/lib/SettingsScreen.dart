import 'package:flutter/material.dart';

import 'NotificationService.dart';
import 'OnboardingScreen.dart';
import 'app_theme.dart';
import 'app_widgets.dart';
///
/// Settings screen with three sections: notification reminders (set/change/
/// cancel the daily check-in via [NotificationService] with eminder time
/// persisted separately from the scheduled notification itself -- see
/// [_pickReminderTime]), appearance (dark mode toggle backed by
/// [AppTheme.themeMode]), and an "About" entry that reuses [OnboardingScreen]
/// as an info screen rather than a dedicated about page.
// TODO: Add a dedicated about page ?, I don't know yet, let see how things evolve.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _loadSavedReminderTime();
  }

  /// Restores the previously saved reminder time (if any) so the UI
  /// reflects the actual scheduled notification, not just a fresh default.
  Future<void> _loadSavedReminderTime() async {
    final saved = await NotificationService.getSavedReminderTime();
    if ((saved != null) && (mounted)) {
      setState(() {
        _reminderTime = saved;
      });
    }
  }

  /// Opens a time picker (defaulting to 8:00 PM if no reminder is set yet),
  /// then both schedules the notification and persists the chosen time --
  /// these are two separate calls to [NotificationService] since scheduling
  /// and storage are handled independently there.
  Future<void> _pickReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 20, minute: 0),
    );

    if (picked != null) {
      await NotificationService.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );

      await NotificationService.saveReminderTime(picked.hour, picked.minute);

      setState(() {
        _reminderTime = picked;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Daily reminder set for ${picked.format(context)}'),
          ),
        );
      }
    }
  }

  /// Cancels the scheduled notification and clears the persisted time --
  /// mirrors [_pickReminderTime]'s two-step pattern in reverse.
  Future<void> _cancelReminder() async {
    await NotificationService.cancelDailyReminder();
    await NotificationService.clearSavedReminderTime();
    setState(() {
      _reminderTime = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily reminder turned off')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgets.screenTitle(
                title: 'Notifications',
                subtitle: 'Manage your daily check-in reminder',
              ),

              const SizedBox(height: 20),
              AppWidgets.card(
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: AppTheme.primary,
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'daily check-in reminder',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            _reminderTime != null
                                ? 'Set for ${_reminderTime!.format(context)}'
                                : 'No reminder set',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_reminderTime != null)
                      IconButton(
                        icon: Icon(Icons.close, color: AppTheme.textMuted),
                        onPressed: _cancelReminder,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppWidgets.primaryButton(
                label: _reminderTime != null
                    ? 'Change reminder time'
                    : 'Set daily reminder',
                onPressed: _pickReminderTime,
              ),

              const SizedBox(height: 24),

              AppWidgets.screenTitle(
                  title: 'Appearance',
                  subtitle: 'Choose how That Shy Life looks',
              ),
              const SizedBox(height: 16),

          AppWidgets.card(
            child: Row(
              children: [
                Icon(Icons.dark_mode_outlined, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              ValueListenableBuilder<ThemeMode>(
                  valueListenable: AppTheme.themeMode,
                  builder: (context, mode, _){
                    return Switch(
                    value: mode == ThemeMode.dark,
                      activeThumbColor: AppTheme.primary,
                        onChanged: (value) => AppTheme.setDarkMode(value),
                    );
                  },
              ),
              ],
            ),
          ),

              const SizedBox(height: 16),

              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OnboardingScreen(onDone: () => Navigator.pop(context)),
                  ),
                ),
                child: AppWidgets.card(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'About That Shy Life',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppTheme.textMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
