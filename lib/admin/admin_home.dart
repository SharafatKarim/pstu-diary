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

    if (supabase.auth.currentSession == null) {
      context.go('/signup');
    }

    final role = supabase
        .from('profiles')
        .select('role')
        .eq('id', supabase.auth.currentSession!.user.id)
        .single();
    var userRole = supabase.from('profiles').select().eq('id', supabase.auth.currentSession!.user.id.toString()).single();

    developer.log(role.toString());
    developer.log(userRole.toString());

    // userRole.then((value) {
      // developer.log(value.toString());
      // Uncomment the following lines to enforce admin access
    //   if (value['role'] != 'admin') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('You are not authorized to access this page')),
    //     );
    //     context.go('/signup');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}