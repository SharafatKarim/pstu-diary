import 'package:diary/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const ResponsiveLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Faculties',
                ),
                NavigationDestination(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  label: 'Administor',
                ),
                NavigationDestination(
                  icon: Icon(Icons.home_repair_service_sharp),
                  label: 'Services',
                ),
                NavigationDestination(
                  icon: Icon(Icons.extension_rounded),
                  label: 'Extras',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        } else if (constraints.maxWidth < 1200) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: settingsProvider.navigationRailLabelType,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Faculties'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.admin_panel_settings_outlined),
                      label: Text('Administor'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.home_repair_service_sharp),
                      label: Text('Services'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.extension_rounded),
                      label: Text('Extras'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: constraints.maxWidth >= 1200
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  extended: constraints.maxWidth >= 1200 ? true : false,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Faculties'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.admin_panel_settings_outlined),
                      label: Text('Administor'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.home_repair_service_sharp),
                      label: Text('Services'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.extension_rounded),
                      label: Text('Extras'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }
      },
    );
  }
}
