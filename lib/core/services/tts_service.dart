import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speakOrderReady({
    required int orderNumber,
    required String language,
    required double rate,
  }) async {
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(rate);
    await _tts.speak('Заказ номер $orderNumber даяр болду');
  }
}
