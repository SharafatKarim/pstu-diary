import 'dart:developer' as developer;

import 'package:diary/router.dart';
import 'package:diary/shared/constants.dart';
import 'package:diary/l10n/app_localizations.dart';
import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  await Supabase.initialize(
    url: env['SUPABASE_URL'] ?? '',
    anonKey: env['SUPABASE_ANON_KEY'] ?? '',
  );

  developer.log("Starting app...");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Constants.appName,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.helloWorld,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
