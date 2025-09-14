// import 'package:diary/l10n/app_localizations.dart';
import 'package:diary/pages/administer.dart';
import 'package:diary/pages/extras.dart';
import 'package:diary/pages/faculties.dart';
import 'package:diary/pages/services.dart';
import 'package:diary/pages/settings.dart';
import 'package:diary/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
    int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Faculties(),
    const Administer(),
    const Services(),
    const Extras(),
    const Settings(),
  ];

  // TODO :: Localization
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(AppLocalizations.of(context)!.helloWorld),
  //     ),
  //     body: Center(
  //       child: Text(
  //         AppLocalizations.of(context)!.displayText,
  //         style: TextStyle(fontSize: 30),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      child: _screens[_selectedIndex],
    );
  }
}