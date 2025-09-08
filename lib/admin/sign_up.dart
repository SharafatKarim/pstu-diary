import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin | Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SupaEmailAuth(
          onSignInComplete: (response) {
            context.go('/home');
          },
          onSignUpComplete: (response) {
            if (response.session != null) {
              Supabase.instance.client.auth.setSession(response.session! as String);
              context.go('/home');
            }
          },
        ),
      ),
    );
  }
}