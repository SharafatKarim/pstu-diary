// import 'package:diary/l10n/app_localizations.dart';
import 'dart:developer' as developer;

import 'package:diary/main.dart';
import 'package:diary/pages/administor.dart';
import 'package:diary/pages/extras.dart';
import 'package:diary/pages/faculties.dart';
import 'package:diary/pages/services.dart';
import 'package:diary/pages/settings.dart';
import 'package:diary/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Redirect to admin if logged in as admin

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
    const Administor(),
    const Services(),
    const Extras(),
    const Settings(),
  ];

  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentUser !=null) {
      _checkRole();
    }
  }

  Future<void> _checkRole() async {
    try {
      final role = await supabase
          .from('profiles')
          .select('role')
          .eq('id', supabase.auth.currentSession!.user.id)
          .single();

      developer.log('role: $role');
      if (role['role'] == 'admin') {
        if (!mounted) return;
        context.go('/admin');
      }
    } catch (e) {
      developer.log('Error fetching role: $e');
    }
  }

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
