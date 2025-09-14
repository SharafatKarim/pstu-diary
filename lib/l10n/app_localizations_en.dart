// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'PSTU Diary';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get displayText => 'This is a sample App';

  @override
  String get description =>
      'PSTU Diary is a cross-platform application designed to help students and faculty members of Patuakhali Science and Technology University (PSTU) efficiently access resources and contact information of various departments, faculties, and administrative offices. The app aims to provide a user-friendly interface for quick navigation and retrieval of essential information, enhancing the overall experience of the university community.';
}
