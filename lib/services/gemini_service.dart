import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String _model = 'gemini-flash-latest';

  late final Dio _dio;
  late final String _apiKey;

  GeminiService() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  /// 단일 텍스트 요청용 (피드백 등)
  Map<String, dynamic> _buildRequestBody(
    String text, {
    Map<String, dynamic>? generationConfig,
  }) {
    final config = <String, dynamic>{
      'temperature': 0.6,
      'topK': 40,
      'topP': 0.95,
      'maxOutputTokens': 1024,
      'thinkingConfig': <String, dynamic>{'thinkingBudget': 0},
    };
    if (generationConfig != null) {
      config.addAll(generationConfig);
    }
    return {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': text},
          ],
        },
      ],
      'generationConfig': config,
    };
  }

  /// 멀티턴 대화 형식: contents를 user/model 교대로 구성
  Future<String> generateAIResponse({
    required String systemPrompt,
    required List<Map<String, String>> conversationHistory,
    required String userMessage,
  }) async {
    // sender 'user' -> role 'user', sender 'ai' -> role 'model'
    final contents = <Map<String, dynamic>>[];
    for (var message in conversationHistory) {
      final role = message['sender'] == 'user' ? 'user' : 'model';
      contents.add({
        'role': role,
        'parts': [
          {'text': message['content'] ?? ''},
        ],
      });
    }
    // 현재 상담원(유저) 메시지 추가
    contents.add({
      'role': 'user',
      'parts': [
        {'text': userMessage},
      ],
    });

    final body = {
      'system_instruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
      'contents': contents,
      'generationConfig': {
        'temperature': 0.6,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 1024,
        'thinkingConfig': <String, dynamic>{'thinkingBudget': 0},
      },
    };

    developer.log(
      '=== [Chat] System Prompt ===\n$systemPrompt',
      name: 'GeminiService',
    );
    developer.log(
      '=== [Chat] Contents (${contents.length} messages) ===\n'
      '${const JsonEncoder.withIndent('  ').convert(contents)}',
      name: 'GeminiService',
    );

    final response = await _dio.post<Map<String, dynamic>>(
      '/models/$_model:generateContent',
      queryParameters: {'key': _apiKey},
      data: body,
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('No response from Gemini API');
    }

    final candidates = responseData['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    final content = candidates[0]['content'] as Map<String, dynamic>?;
    if (content == null) {
      throw Exception('No response from Gemini API');
    }

    final parts = content['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    var text = parts[0]['text'] as String? ?? '';
    text = text.trim().replaceAll('\n', ' ');
    return text;
  }

  /// 피드백은 전체 JSON이 필요하므로 generateContent 유지, 요청 형식만 통일
  Future<Map<String, dynamic>> generateFeedback({
    required List<Map<String, String>> conversationHistory,
  }) async {
    final conversationText = StringBuffer('=== 상담 대화 내역 ===\n');
    for (var message in conversationHistory) {
      final speaker = message['sender'] == 'user' ? '상담원' : 'AI 학생';
      conversationText.writeln('$speaker: ${message['content']}');
    }

    final feedbackPrompt =
        '''
다음 상담 대화를 분석하고 피드백을 제공해주세요.

${conversationText.toString()}

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

    final body = _buildRequestBody(
      feedbackPrompt,
      generationConfig: {'temperature': 0.7, 'maxOutputTokens': 2048},
    );
    // 피드백은 스트리밍 불필요, generateContent 사용
    final response = await _dio.post<Map<String, dynamic>>(
      '/models/$_model:generateContent',
      queryParameters: {'key': _apiKey},
      data: body,
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('No response from Gemini API');
    }

    final candidates = responseData['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    final content = candidates[0]['content'] as Map<String, dynamic>?;
    if (content == null) {
      throw Exception('No response from Gemini API');
    }

    final parts = content['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    var text = parts[0]['text'] as String? ?? '';
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
  }
}
