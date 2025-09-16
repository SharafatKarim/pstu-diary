import 'package:diary/providers/settings_provider.dart';
import 'package:diary/providers/theme_provider.dart';
import 'package:diary/router.dart';
import 'package:diary/shared/constants.dart';
import 'package:diary/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(sharedPreferences)),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(sharedPreferences),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: Constants.appName,
            theme: themeProvider.themeData,
            darkTheme: themeProvider.darkThemeData,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.helloWorld,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
}
