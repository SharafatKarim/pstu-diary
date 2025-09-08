import 'package:diary/admin/admin_home.dart';
import 'package:diary/admin/sign_up.dart';
import 'package:diary/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminHome(),
    ),
  ],
  initialLocation: '/signup',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);