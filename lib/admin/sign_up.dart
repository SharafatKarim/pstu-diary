import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Access')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        child: const Icon(Icons.home),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: SupaEmailAuth(
                      onSignInComplete: (response) {
                        context.go('/admin');
                      },
                      onSignUpComplete: (response) {
                        context.go('/admin');
                      },
                      metadataFields: [
                        MetaDataField(
                          prefixIcon: const Icon(Icons.person),
                          label: 'Username',
                          key: 'username',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter something';
                            }
                            return null;
                          },
                        ),
                        BooleanMetaDataField(
                          label: 'I agree not to do any harmful activities',
                          key: 'user_agreement',
                          checkboxPosition: ListTileControlAffinity.leading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
