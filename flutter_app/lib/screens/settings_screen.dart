import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your app settings',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingRow(
                      icon: Icons.person,
                      title: 'Profile',
                      subtitle: 'Manage your profile',
                      onTap: () {
                        // TODO: Implement profile management
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile management would open here')),
                        );
                      },
                    ),
                    const Divider(height: 24),
                    _buildSettingRow(
                      icon: Icons.lock,
                      title: 'Privacy',
                      subtitle: 'Manage privacy settings',
                      onTap: () {
                        // TODO: Implement privacy settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy settings would open here')),
                        );
                      },
                    ),
                    const Divider(height: 24),
                    _buildSettingRow(
                      icon: Icons.security,
                      title: 'Security',
                      subtitle: 'Manage security settings',
                      onTap: () {
                        // TODO: Implement security settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Security settings would open here')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferences',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                    ),
                    const Divider(height: 8),
                    SwitchListTile(
                      title: const Text('Notifications'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    const Divider(height: 8),
                    _buildDropdownSetting(
                      icon: Icons.language,
                      title: 'Language',
                      value: _selectedLanguage,
                      items: const ['English', 'Spanish', 'French', 'German'],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Actions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingRow(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Log out of your account',
                      onTap: () async {
                        try {
                          await authProvider.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signed out successfully')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign out failed: $e')),
                          );
                        }
                      },
                    ),
                    const Divider(height: 24),
                    _buildSettingRow(
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account',
                      onTap: () {
                        // TODO: Implement account deletion
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account deletion would happen here')),
                        );
                      },
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[700]),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDropdownSetting({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}