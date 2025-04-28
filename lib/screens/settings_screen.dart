// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_design_system.dart';
import '../utils/theme.dart';
import 'profile_edit_screen.dart';
import '../services/auth_service.dart';
import '../widgets/base_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedLogoutTime = '30 minutes';

  final List<String> _logoutTimes = [
    '15 minutes',
    '30 minutes',
    '1 hour',
    'Never',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Settings',
      body: ListView(
        padding: AppDesignSystem.defaultPadding,
        children: [
          // Notification Settings
          AppDesignSystem.card(
            child: SwitchListTile(
              title: Text(
                'Notifications',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                'Enable or disable app notifications',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Dark Mode Settings
          AppDesignSystem.card(
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                'Switch between light and dark theme',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                  // TODO: Implement theme switching logic
                });
              },
              activeColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Auto Logout Time
          AppDesignSystem.card(
            child: Padding(
              padding: AppDesignSystem.sectionPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto Logout Time',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLogoutTime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: AppDesignSystem.defaultBorderRadius,
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items:
                        _logoutTimes
                            .map(
                              (time) => DropdownMenuItem(
                                value: time,
                                child: Text(time),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLogoutTime = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Edit Profile
          AppDesignSystem.card(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.person, color: AppColors.primary),
              title: Text(
                'Edit Profile',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Logout
          AppDesignSystem.card(
            onTap: _logout,
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'Logout',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await AuthService().logout();
      // TODO: Navigate to login screen
      // Navigator.pushAndRemoveUntil(...)
    }
  }
}
