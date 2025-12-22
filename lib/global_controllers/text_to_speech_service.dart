// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:language_detector/language_detector.dart';
//
// class TextToSpeechService {
//   final FlutterTts flutterTts = FlutterTts();
//
//   Future<void> speak(String text) async {
//     String language = await LanguageDetector.getLanguageName(content: text);
//     String textLang = "en-US";
//     if (language == "English") {
//       textLang = "en-US";
//     } else {
//       textLang = "ar-SA";
//     }
//     await flutterTts.setLanguage(textLang);
//     await flutterTts.setPitch(1);
//     await flutterTts.speak(text);
//   }
// }