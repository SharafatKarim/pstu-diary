import 'package:supabase_flutter/supabase_flutter.dart';

class AiService {
  final _supabase = Supabase.instance.client;
  static const functionName = 'gemini-chat';

  Future<String> chatWithGemini(String userMessage) async {
    try {
      final res = await _supabase.functions.invoke(
        functionName,
        body: {'text': userMessage},
      );

      if (res.status >= 400) {
        final err = (res.data is Map && res.data['error'] != null)
            ? res.data['error'].toString()
            : 'সার্ভার ত্রুটি (${res.status})';
        return 'দুঃখিত, একটি সমস্যা হয়েছে: $err';
      }

      final data = res.data as Map<String, dynamic>?;
      return (data != null && data['answer'] != null)
          ? data['answer'].toString()
          : 'দুঃখিত, কোনো উত্তর পাওয়া যায়নি।';
    } catch (e) {
      return e.toString().contains('Failed to fetch')
          ? 'দুঃখিত, নেটওয়ার্ক সমস্যা হয়েছে। আপনার ইন্টারনেট সংযোগ চেক করুন।'
          : 'দুঃখিত, একটি ত্রুটি ঘটেছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
    }
  }
}
