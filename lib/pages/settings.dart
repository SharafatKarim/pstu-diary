import 'package:diary/l10n/app_localizations.dart';
import 'package:diary/providers/settings_provider.dart';
import 'package:diary/providers/theme_provider.dart';
import 'package:diary/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // local-only switches for demo features not provided by app-wide providers
  bool _notifications = true;
  bool _newsletter = false;

  final _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.pink,
    Colors.lime,
    Colors.brown,
    Colors.cyan,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.yellow,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // TODO: Set some settings via SettingsProvider
    final settingsProvider = Provider.of<SettingsProvider>(context);

    const contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 20);

    final appearance = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Appearance'),
        _card([
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text(Constants.appName),
            subtitle: Text(_themeModeLabel(themeProvider.themeMode)),
            onTap: () => _pickTheme(context, themeProvider),
          ),
          const Divider(height: 0),
          // Force Dark Mode switch — toggles between dark and system
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Force Dark Mode'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (v) => themeProvider.setThemeMode(
              v ? ThemeMode.dark : ThemeMode.system,
            ),
          ),
          const Divider(height: 0),
          // Primary color picker
          ListTile(
            leading: const Icon(Icons.colorize_outlined),
            title: const Text('Primary Color'),
            subtitle: const Text('Tap to choose'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _availableColors.map((color) {
                final selected = themeProvider.primaryColor == color;
                return GestureDetector(
                  onTap: () => themeProvider.setPrimaryColor(color),
                  child: CircleAvatar(
                    radius: selected ? 22 : 18,
                    backgroundColor: color,
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ]),
      ],
    );

    final notifications = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Notifications'),
        _card([
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Push Notifications'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(height: 0),
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: const Text('Email Newsletter'),
            value: _newsletter,
            onChanged: (v) => setState(() => _newsletter = v),
          ),
        ]),
      ],
    );

    final account = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Account'),
        _card([
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Admin Login'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/signup');
            },
          ),
        ]),
      ],
    );

    final more = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('More'),
        _card([
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            onTap: () =>
                _showInfo(context, 'Help', 'Help Center not implemented.'),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacy & Security'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showInfo(
              context,
              'Privacy & Security',
              'Privacy & Security not defined yet.',
            ),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: Constants.appName,
              applicationVersion: Constants.version,
              applicationIcon: const Icon(Icons.settings),
              children: [Text(AppLocalizations.of(context)!.description)],
            ),
          ),
        ]),
      ],
    );

    final footer = Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Text(
            "Version ${Constants.version}",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );

    final sections = [appearance, notifications, account, more];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: contentPadding,
            children: [
              ...sections.expand((s) => [s, const SizedBox(height: 28)]),
              footer,
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  Widget _card(List<Widget> children) => Card(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Column(mainAxisSize: MainAxisSize.min, children: children),
  );

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  Future<void> _pickTheme(
    BuildContext context,
    ThemeProvider themeProvider,
  ) async {
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: RadioGroup<ThemeMode>(
            groupValue: themeProvider.themeMode,
            onChanged: (v) => Navigator.pop(ctx, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThemeMode.values.map((mode) {
                return ListTile(
                  title: Text(_themeModeLabel(mode)),
                  leading: Radio<ThemeMode>(value: mode),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      themeProvider.setThemeMode(selected);
    }
  }

  void _showInfo(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}
