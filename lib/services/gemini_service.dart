import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1';
  static const String _model = 'gemini-flash-latest';

  late final Dio _dio;
  late final String _apiKey;

  GeminiService() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<String> generateAIResponse({
    required String systemPrompt,
    required List<Map<String, String>> conversationHistory,
    required String userMessage,
  }) async {
    try {
      String fullPrompt = '$systemPrompt\n\n=== 대화 내역 ===\n';

      for (var message in conversationHistory) {
        final speaker = message['sender'] == 'user' ? '상담원' : 'AI 학생';
        fullPrompt += '$speaker: ${message['content']}\n';
      }

      fullPrompt += '상담원: $userMessage\n';
      fullPrompt += 'AI 학생:';

      final response = await _dio.post(
        '/models/$_model:generateContent',
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': fullPrompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.9,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        },
      );

      final candidates = response.data['candidates'] as List;
      if (candidates.isEmpty) {
        throw Exception('No response from Gemini API');
      }

      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      final text = parts[0]['text'] as String;

      return text.trim();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'API Error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  Future<Map<String, dynamic>> generateFeedback({
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      String conversationText = '=== 상담 대화 내역 ===\n';
      for (var message in conversationHistory) {
        final speaker = message['sender'] == 'user' ? '상담원' : 'AI 학생';
        conversationText += '$speaker: ${message['content']}\n';
      }

      String feedbackPrompt =
          '''
다음 상담 대화를 분석하고 피드백을 제공해주세요.

$conversationText

평가 기준:
1. 공감 표현 (1-5점): 상담원이 학생의 감정을 얼마나 잘 이해하고 공감했는가
2. 경청 능력 (1-5점): 학생의 이야기를 잘 듣고 적절한 질문을 했는가
3. 질문의 적절성 (1-5점): 질문이 대화를 이어가는 데 도움이 되었는가
4. 해결책 제안 (1-5점): 실질적이고 적절한 도움을 제공했는가

출력 형식은 다음 JSON 형식으로 작성해주세요:
{
  "scores": {
    "empathy": 점수(1-5),
    "listening": 점수(1-5),
    "questioning": 점수(1-5),
    "solution": 점수(1-5)
  },
  "goodPoints": "잘한 점을 구체적으로 2-3문장",
  "improvements": "개선할 점을 구체적으로 2-3문장",
  "recommendedScenarios": ["추천 시나리오 ID"]
}

JSON만 출력하고 다른 설명은 하지 마세요.
''';

      final response = await _dio.post(
        '/models/$_model:generateContent',
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': feedbackPrompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          },
        },
      );

      final candidates = response.data['candidates'] as List;
      if (candidates.isEmpty) {
        throw Exception('No response from Gemini API');
      }

      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      String text = parts[0]['text'] as String;

      text = text.trim();
      if (text.startsWith('```json')) {
        text = text.substring(7);
      }
      if (text.startsWith('```')) {
        text = text.substring(3);
      }
      if (text.endsWith('```')) {
        text = text.substring(0, text.length - 3);
      }
      text = text.trim();

      final feedbackJson = jsonDecode(text) as Map<String, dynamic>;
      return feedbackJson;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'API Error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
