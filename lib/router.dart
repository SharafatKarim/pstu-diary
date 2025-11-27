import 'dart:developer' as developer;

import 'package:diary/admin/admin_home.dart';
import 'package:diary/admin/no_access.dart';
import 'package:diary/admin/sign_up.dart';
import 'package:diary/client/admin_page.dart';
import 'package:diary/client/faculty.dart';
import 'package:diary/client/person_detail.dart';
import 'package:diary/client/service_page.dart';
import 'package:diary/client/shared.dart';
import 'package:diary/main.dart';
import 'package:diary/pages/my_home_page.dart';
import 'package:diary/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage()),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(
      path: '/faculty',
      builder: (context, state) {
        final facultyName = state.uri.queryParameters['name'] ?? '';
        return Faculty(facultyName: facultyName);
      },
    ),
    GoRoute(
      path: '/administration',
      builder: (context, state) {
        final name = state.uri.queryParameters['name'] ?? '';
        return AdminPage(name: name);
      },
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        final name = state.uri.queryParameters['name'] ?? '';
        return ServicePage(name: name);
      },
    ),
    GoRoute(
      path: '/person-detail',
      builder: (context, state) {
        final person = state.extra as PersonItem?;
        if (person == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('ত্রুটি')),
            body: const Center(child: Text('ব্যক্তির তথ্য পাওয়া যায়নি')),
          );
        }
        return PersonDetail(person: person);
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminHome()),
    GoRoute(path: '/no-access', builder: (context, state) => const NoAccess()),
  ],
  initialLocation: '/',
  redirect: (context, state) async {
    // Only redirect on initial load to home page
    if (state.matchedLocation == '/') {
      final session = supabase.auth.currentSession;
      if (session != null) {
        try {
          final role = await supabase
              .from('profiles')
              .select('role')
              .eq('id', session.user.id)
              .single();

          developer.log('User role: ${role['role']}');

          if (role['role'] == 'admin') {
            return '/admin';
          }
        } catch (e) {
          developer.log('Error checking user role: $e');
        }
      }
    }
    return null; // No redirect
  },
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text(state.error.toString()))),
);
