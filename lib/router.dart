import 'package:diary/admin/admin_home.dart';
import 'package:diary/admin/no_access.dart';
import 'package:diary/admin/sign_up.dart';
import 'package:diary/client/admin_page.dart';
import 'package:diary/client/faculty.dart';
import 'package:diary/client/service_page.dart';
import 'package:diary/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage()),
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
        final adminFaculty = state.uri.queryParameters['name'] ?? '';
        return AdminPage();
      },
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        final serviceFaculty = state.uri.queryParameters['name'] ?? '';
        return ServicePage();
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminHome()),
    GoRoute(path: '/no-access', builder: (context, state) => const NoAccess()),
  ],
  initialLocation: '/',
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text(state.error.toString()))),
);
