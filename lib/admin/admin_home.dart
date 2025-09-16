import 'dart:developer' as developer;

import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (supabase.auth.currentSession == null) {
        context.go('/signup');
      } else {
        _checkRole();
      }
    });
  }

  Future<void> _checkRole() async {
    try {
      final role = await supabase
          .from('profiles')
          .select('role')
          .eq('id', supabase.auth.currentSession!.user.id)
          .single();

      developer.log('role: $role');
      if (role['role'] != 'admin') {
        if (!mounted) return;
        context.go('/no-access');
      }
    } catch (e) {
      developer.log('Error fetching role: $e');
      if (!mounted) return;
      context.go('/no-access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
