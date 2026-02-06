# 순차적 개발 계획서
## AI Psychiatry Training App

---

## 개발 계획 개요

이 문서는 PRD를 기준으로 작성된 **단계별 개발 계획**입니다.
각 단계는 독립적으로 실행 가능하며, 순서대로 구현하면 최종 MVP가 완성됩니다.

**개발 원칙:**
- 한 번에 하나의 단계만 구현
- 각 단계 완료 후 테스트 및 확인
- 다음 단계로 넘어가기 전에 현재 단계가 완벽히 동작해야 함

---

## Phase 1: 프로젝트 기본 세팅 (1-2일)

### Step 1.1: Flutter 프로젝트 초기화
**목표**: Flutter 프로젝트 생성 및 기본 구조 설정

**작업 내용:**
```bash
# 1. Flutter 프로젝트 생성
flutter create ai_psychiatry_training

# 2. 프로젝트 디렉토리로 이동
cd ai_psychiatry_training

# 3. 불필요한 파일 정리
# - test 폴더의 기본 테스트 파일 삭제 (선택)
# - README.md 업데이트
```

**완료 조건:**
- [ ] Flutter 프로젝트가 정상적으로 생성됨
- [ ] `flutter run` 명령어로 기본 앱 실행 확인
- [ ] Android 또는 iOS 에뮬레이터에서 "Hello World" 화면 표시

**예상 소요 시간**: 30분

---

### Step 1.2: pubspec.yaml 의존성 추가
**목표**: 필요한 패키지 설치

**작업 내용:**
`pubspec.yaml` 파일에 다음 의존성 추가:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 상태 관리
  flutter_riverpod: ^2.4.0

  # HTTP 클라이언트
  dio: ^5.4.0

  # 로컬 저장소
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # 라우팅
  go_router: ^13.0.0

  # UUID 생성
  uuid: ^4.3.0

  # JSON 직렬화
  json_annotation: ^4.8.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

  # JSON 직렬화 코드 생성
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
```

**실행 명령:**
```bash
flutter pub get
```

**완료 조건:**
- [ ] 모든 패키지가 정상적으로 설치됨
- [ ] `flutter pub get` 실행 시 에러 없음
- [ ] 앱이 여전히 정상적으로 실행됨

**예상 소요 시간**: 20분

---

### Step 1.3: 프로젝트 폴더 구조 생성
**목표**: 깔끔한 폴더 구조 설정

**작업 내용:**
`lib` 폴더 내에 다음 구조 생성:

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── colors.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── router/
│       └── app_router.dart
├── models/
│   ├── scenario.dart
│   ├── chat_message.dart
│   ├── training_session.dart
│   └── feedback.dart
├── providers/
│   ├── scenario_provider.dart
│   ├── session_provider.dart
│   └── chat_provider.dart
├── services/
│   ├── gemini_service.dart
│   └── storage_service.dart
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   ├── scenario_detail/
│   │   └── scenario_detail_screen.dart
│   ├── chat/
│   │   └── chat_screen.dart
│   ├── feedback/
│   │   └── feedback_screen.dart
│   └── history/
│       └── history_screen.dart
└── widgets/
    ├── scenario_card.dart
    ├── chat_bubble.dart
    └── progress_indicator.dart
```

**실행 방법:**
수동으로 폴더 및 파일 생성 (빈 파일로 생성)

**완료 조건:**
- [ ] 모든 폴더가 생성됨
- [ ] 각 폴더에 필요한 빈 Dart 파일들이 생성됨

**예상 소요 시간**: 15분

---

### Step 1.4: Material Design 3 테마 설정
**목표**: 앱 전체에 적용될 테마 정의

**작업 내용:**

**1. `lib/core/constants/colors.dart` 작성:**
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // Secondary Colors
  static const Color accent = Color(0xFFFF9800);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Text Colors
  static const Color primaryText = Color(0xFF212121);
  static const Color secondaryText = Color(0xFF757575);
  static const Color hintText = Color(0xFFBDBDBD);
}
```

**2. `lib/core/theme/app_theme.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        secondary: AppColors.accent,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.primaryText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.secondaryText,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: AppColors.hintText,
        ),
      ),
    );
  }
}
```

**3. `lib/main.dart` 업데이트:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 상담 트레이닝',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('AI Psychiatry Training App'),
        ),
      ),
    );
  }
}
```

**완료 조건:**
- [ ] 테마 파일들이 정상적으로 작성됨
- [ ] 앱 실행 시 테마가 적용됨
- [ ] Material Design 3 스타일 확인

**예상 소요 시간**: 30분

---

## Phase 2: 데이터 모델 정의 (1일)

### Step 2.1: Scenario 모델 작성
**목표**: 시나리오 데이터 구조 정의

**작업 내용:**

**`lib/models/scenario.dart` 작성:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'scenario.g.dart';

@JsonSerializable()
class Scenario {
  final String id;
  final String title;
  final String description;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final int estimatedTime; // minutes
  final String category;
  final String background;
  final String learningGoals;
  final String systemPrompt;
  final Map<String, dynamic> characterProfile;

  Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedTime,
    required this.category,
    required this.background,
    required this.learningGoals,
    required this.systemPrompt,
    required this.characterProfile,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioToJson(this);
}
```

**코드 생성:**
```bash
flutter pub run build_runner build
```

**완료 조건:**
- [ ] Scenario 모델 작성 완료
- [ ] `scenario.g.dart` 파일이 자동 생성됨
- [ ] 빌드 에러 없음

**예상 소요 시간**: 20분

---

### Step 2.2: ChatMessage 모델 작성
**목표**: 대화 메시지 데이터 구조 정의

**작업 내용:**

**`lib/models/chat_message.dart` 작성:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  final String id;
  final String sessionId;
  final String sender; // 'user' or 'ai'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  bool get isUser => sender == 'user';
  bool get isAI => sender == 'ai';
}
```

**코드 생성:**
```bash
flutter pub run build_runner build
```

**완료 조건:**
- [ ] ChatMessage 모델 작성 완료
- [ ] `chat_message.g.dart` 파일이 자동 생성됨
- [ ] 빌드 에러 없음

**예상 소요 시간**: 15분

---

### Step 2.3: TrainingSession 모델 작성
**목표**: 훈련 세션 데이터 구조 정의

**작업 내용:**

**`lib/models/training_session.dart` 작성:**
```dart
import 'package:json_annotation/json_annotation.dart';
import 'chat_message.dart';
import 'feedback.dart';

part 'training_session.g.dart';

@JsonSerializable()
class TrainingSession {
  final String id;
  final String scenarioId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ChatMessage> messages;
  final bool isCompleted;
  final Feedback? feedback;

  TrainingSession({
    required this.id,
    required this.scenarioId,
    required this.startTime,
    this.endTime,
    required this.messages,
    this.isCompleted = false,
    this.feedback,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) => _$TrainingSessionFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingSessionToJson(this);

  // 세션 복사 (메시지 추가 등에 사용)
  TrainingSession copyWith({
    String? id,
    String? scenarioId,
    DateTime? startTime,
    DateTime? endTime,
    List<ChatMessage>? messages,
    bool? isCompleted,
    Feedback? feedback,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      messages: messages ?? this.messages,
      isCompleted: isCompleted ?? this.isCompleted,
      feedback: feedback ?? this.feedback,
    );
  }
}
```

**코드 생성:**
```bash
flutter pub run build_runner build
```

**완료 조건:**
- [ ] TrainingSession 모델 작성 완료
- [ ] `training_session.g.dart` 파일이 자동 생성됨
- [ ] 빌드 에러 없음

**예상 소요 시간**: 20분

---

### Step 2.4: Feedback 모델 작성
**목표**: 피드백 데이터 구조 정의

**작업 내용:**

**`lib/models/feedback.dart` 작성:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  final String id;
  final String sessionId;
  final Map<String, int> scores; // {'empathy': 4, 'listening': 5, ...}
  final String goodPoints;
  final String improvements;
  final List<String> recommendedScenarios;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.sessionId,
    required this.scores,
    required this.goodPoints,
    required this.improvements,
    required this.recommendedScenarios,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);

  // 평균 점수 계산
  double get averageScore {
    if (scores.isEmpty) return 0;
    int total = scores.values.reduce((a, b) => a + b);
    return total / scores.length;
  }
}
```

**코드 생성:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**완료 조건:**
- [ ] Feedback 모델 작성 완료
- [ ] 모든 `.g.dart` 파일이 정상적으로 생성됨
- [ ] 빌드 에러 없음

**예상 소요 시간**: 20분

---

## Phase 3: 시나리오 데이터 준비 (1일)

### Step 3.1: 시나리오 JSON 파일 생성
**목표**: 샘플 시나리오 데이터 작성

**작업 내용:**

**1. `assets/scenarios/` 폴더 생성**

**2. `assets/scenarios/scenarios.json` 작성:**
```json
[
  {
    "id": "scenario_001",
    "title": "시험 불안",
    "description": "대입 시험을 앞둔 학생의 극심한 불안감",
    "difficulty": "beginner",
    "estimatedTime": 15,
    "category": "학업 스트레스",
    "background": "고3 학생 수진이는 대입 시험을 2주 앞두고 극심한 불안감을 호소하고 있습니다. 최근 밤에 잠을 제대로 자지 못하고, 공부를 해도 집중이 안 된다고 합니다. 성적은 중상위권이지만, 시험 결과가 나쁠 것 같은 불안감에 시달리고 있습니다.",
    "learningGoals": "• 학생의 불안 감정에 공감하기\n• 불안의 구체적인 원인 파악하기\n• 실질적인 불안 관리 방법 제안하기\n• 과도한 조언이나 해결책 강요 피하기",
    "systemPrompt": "당신은 고3 학생 '수진'입니다. 대입 시험을 2주 앞두고 극심한 불안감을 느끼고 있습니다.\n\n배경 상황:\n- 평소 성적은 중상위권\n- 최근 일주일간 하루 4-5시간만 수면\n- 공부할 때 집중이 안 됨\n- \"내가 실패하면 어떡하지\"라는 생각이 반복됨\n\n성격:\n- 성실하고 책임감이 강함\n- 완벽을 추구하는 경향\n- 처음에는 쉽게 마음을 열지 않음\n\n대화 방식:\n- 처음에는 \"괜찮다\", \"그냥 그렇다\" 같은 짧은 대답\n- 상담원이 진심으로 공감해주면 점차 구체적으로 이야기\n- 조언을 강요하면 방어적으로 변함\n- 경청과 공감에는 긍정적으로 반응\n\n절대 하지 말 것:\n- 너무 쉽게 \"이해했어요\", \"이제 괜찮아요\" 라고 말하지 마세요\n- 문제가 빠르게 해결되지 않습니다\n- 상담원의 태도에 따라 반응이 달라져야 합니다\n\n당신의 목표는 현실적인 고민을 가진 학생을 연기하는 것입니다.",
    "characterProfile": {
      "name": "수진",
      "age": 18,
      "personality": "성실하고 책임감 강함, 완벽주의 성향",
      "initialEmotion": {
        "anxiety": 80,
        "fatigue": 60,
        "confidence": 20
      }
    }
  },
  {
    "id": "scenario_002",
    "title": "친구 관계 고민",
    "description": "친한 친구와 갈등이 생긴 상황",
    "difficulty": "intermediate",
    "estimatedTime": 20,
    "category": "대인관계",
    "background": "중2 학생 민수는 가장 친한 친구와 최근 갈등이 생겼습니다. 친구가 다른 친구들과 어울리기 시작하면서 자신을 소외시키는 것 같다고 느낍니다. 먼저 말을 걸어야 할지, 아니면 거리를 둬야 할지 고민하고 있습니다.",
    "learningGoals": "• 학생의 외로움과 배신감에 공감하기\n• 상황을 객관적으로 파악하도록 돕기\n• 성급한 판단을 피하고 여러 관점 제시하기\n• 학생 스스로 결정할 수 있도록 지원하기",
    "systemPrompt": "당신은 중학교 2학년 학생 '민수'입니다. 가장 친한 친구가 다른 친구들과 어울리면서 자신을 소외시키는 것 같아 힘들어하고 있습니다.\n\n배경 상황:\n- 초등학교 때부터 친했던 단짝 친구가 있음\n- 최근 그 친구가 새로운 친구들과 자주 어울림\n- 자신에게는 예전처럼 연락을 잘 안 함\n- 외로움과 배신감을 느끼고 있음\n\n성격:\n- 조용하고 내성적인 편\n- 친구를 매우 소중하게 생각함\n- 감정 표현이 서툰 편\n\n대화 방식:\n- 처음에는 \"괜찮아\"라고 하지만 속으로는 많이 힘듦\n- 공감해주면 조금씩 속마음을 드러냄\n- \"내가 잘못한 게 있을까?\" 같은 자책도 함\n- 친구와의 추억을 이야기하면 감정이 북받침\n\n현실적인 반응:\n- 문제가 쉽게 해결되지 않음\n- 상담원의 조언을 듣고도 여전히 고민함\n- 결정을 내리기 어려워함",
    "characterProfile": {
      "name": "민수",
      "age": 14,
      "personality": "조용하고 내성적, 감정 표현이 서툼",
      "initialEmotion": {
        "loneliness": 75,
        "sadness": 70,
        "confusion": 80
      }
    }
  },
  {
    "id": "scenario_003",
    "title": "가족 갈등",
    "description": "부모님과의 진로 갈등",
    "difficulty": "advanced",
    "estimatedTime": 25,
    "category": "가족",
    "background": "고2 학생 지은이는 예술 계열 진로를 희망하지만, 부모님은 안정적인 이공계를 원합니다. 집에서 진로 이야기만 나오면 싸움이 되고, 부모님을 설득할 방법을 모르겠다고 합니다.",
    "learningGoals": "• 학생의 갈등 상황에 공감하기\n• 부모님과 학생 양쪽의 입장 이해하도록 돕기\n• 건설적인 대화 방법 제안하기\n• 성급한 해결책 제시 피하기",
    "systemPrompt": "당신은 고등학교 2학년 학생 '지은'입니다. 예술 계열 진로를 희망하지만 부모님은 이공계를 원해서 갈등을 겪고 있습니다.\n\n배경 상황:\n- 어릴 때부터 그림 그리기를 좋아함\n- 미술 선생님께 재능이 있다는 말을 들음\n- 부모님은 \"예술로 먹고살기 힘들다\"며 반대\n- 최근 집에서 진로 이야기만 나오면 싸움이 됨\n\n성격:\n- 자기 주장이 있지만 부모님께 죄송한 마음도 있음\n- 감정적으로 대응하는 경향\n- 때로는 포기하고 싶어짐\n\n대화 방식:\n- 처음에는 부모님에 대한 불만을 토로\n- 공감받으면 자신의 꿈에 대해 이야기\n- 하지만 동시에 부모님 걱정도 이해함\n- \"어떻게 해야 할지 모르겠어\"라는 혼란스러움\n\n현실적인 고민:\n- 부모님을 설득할 자신이 없음\n- 미래에 대한 불안감도 있음\n- 쉽게 해결되지 않는 문제임을 알고 있음",
    "characterProfile": {
      "name": "지은",
      "age": 17,
      "personality": "자기 주장이 있지만 가족에 대한 애정도 깊음",
      "initialEmotion": {
        "frustration": 85,
        "sadness": 70,
        "confusion": 75
      }
    }
  }
]
```

**3. `pubspec.yaml`에 assets 추가:**
```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/scenarios/
```

**완료 조건:**
- [ ] scenarios.json 파일 작성 완료
- [ ] pubspec.yaml에 assets 경로 추가
- [ ] `flutter pub get` 실행하여 적용

**예상 소요 시간**: 1시간

---

## Phase 4: 로컬 저장소 서비스 (1일)

### Step 4.1: Hive 초기화
**목표**: Hive 로컬 DB 설정

**작업 내용:**

**`lib/main.dart` 수정:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 상담 트레이닝',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('AI Psychiatry Training App'),
        ),
      ),
    );
  }
}
```

**완료 조건:**
- [ ] Hive 초기화 코드 추가
- [ ] 앱이 정상적으로 실행됨

**예상 소요 시간**: 15분

---

### Step 4.2: StorageService 작성
**목표**: 로컬 저장소 관리 서비스 구현

**작업 내용:**

**`lib/services/storage_service.dart` 작성:**
```dart
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_session.dart';

class StorageService {
  static const String _sessionsBoxName = 'training_sessions';
  static const String _completedScenariosKey = 'completed_scenarios';

  // Hive Box
  late Box<String> _sessionsBox;

  // SharedPreferences
  late SharedPreferences _prefs;

  // 초기화
  Future<void> init() async {
    _sessionsBox = await Hive.openBox<String>(_sessionsBoxName);
    _prefs = await SharedPreferences.getInstance();
  }

  // 세션 저장
  Future<void> saveSession(TrainingSession session) async {
    final jsonString = jsonEncode(session.toJson());
    await _sessionsBox.put(session.id, jsonString);
  }

  // 세션 불러오기
  TrainingSession? getSession(String sessionId) {
    final jsonString = _sessionsBox.get(sessionId);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return TrainingSession.fromJson(json);
  }

  // 모든 세션 불러오기
  List<TrainingSession> getAllSessions() {
    final sessions = <TrainingSession>[];

    for (var key in _sessionsBox.keys) {
      final jsonString = _sessionsBox.get(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        sessions.add(TrainingSession.fromJson(json));
      }
    }

    // 시작 시간 기준 내림차순 정렬
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  // 완료된 세션만 불러오기
  List<TrainingSession> getCompletedSessions() {
    return getAllSessions().where((s) => s.isCompleted).toList();
  }

  // 시나리오별 완료 여부 확인
  bool isScenarioCompleted(String scenarioId) {
    final completedIds = _prefs.getStringList(_completedScenariosKey) ?? [];
    return completedIds.contains(scenarioId);
  }

  // 시나리오 완료 표시
  Future<void> markScenarioAsCompleted(String scenarioId) async {
    final completedIds = _prefs.getStringList(_completedScenariosKey) ?? [];
    if (!completedIds.contains(scenarioId)) {
      completedIds.add(scenarioId);
      await _prefs.setStringList(_completedScenariosKey, completedIds);
    }
  }

  // 완료한 시나리오 개수
  int getCompletedScenarioCount() {
    return _prefs.getStringList(_completedScenariosKey)?.length ?? 0;
  }

  // 세션 삭제
  Future<void> deleteSession(String sessionId) async {
    await _sessionsBox.delete(sessionId);
  }

  // 모든 데이터 삭제 (테스트용)
  Future<void> clearAll() async {
    await _sessionsBox.clear();
    await _prefs.clear();
  }
}
```

**완료 조건:**
- [ ] StorageService 작성 완료
- [ ] 빌드 에러 없음

**예상 소요 시간**: 30분

---

## Phase 5: Gemini API 서비스 (1일)

### Step 5.1: Gemini API 키 설정
**목표**: API 키를 안전하게 관리

**작업 내용:**

**1. `.env` 파일 생성 (프로젝트 루트):**
```
GEMINI_API_KEY=여기에_실제_API_키_입력
```

**2. `.gitignore`에 추가:**
```
# 환경 변수
.env
```

**3. `pubspec.yaml`에 패키지 추가:**
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

**4. `pubspec.yaml`의 assets에 추가:**
```yaml
flutter:
  assets:
    - .env
    - assets/scenarios/
```

**5. `lib/main.dart` 수정:**
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Hive 초기화
  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

**완료 조건:**
- [ ] .env 파일 생성 (실제 API 키는 나중에 입력)
- [ ] flutter_dotenv 패키지 설치
- [ ] 앱이 정상 실행됨

**예상 소요 시간**: 20분

---

### Step 5.2: GeminiService 작성
**목표**: Gemini API 통신 서비스 구현

**작업 내용:**

**`lib/services/gemini_service.dart` 작성:**
```dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1';
  static const String _model = 'gemini-pro';

  late final Dio _dio;
  late final String _apiKey;

  GeminiService() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  // AI 학생 응답 생성
  Future<String> generateAIResponse({
    required String systemPrompt,
    required List<Map<String, String>> conversationHistory,
    required String userMessage,
  }) async {
    try {
      // 대화 히스토리 구성
      String fullPrompt = systemPrompt + '\n\n=== 대화 내역 ===\n';

      for (var message in conversationHistory) {
        final speaker = message['sender'] == 'user' ? '상담원' : 'AI 학생';
        fullPrompt += '$speaker: ${message['content']}\n';
      }

      fullPrompt += '상담원: $userMessage\n';
      fullPrompt += 'AI 학생:';

      // API 호출
      final response = await _dio.post(
        '/models/$_model:generateContent',
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': fullPrompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.9,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        },
      );

      // 응답 파싱
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
        throw Exception('API Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  // 피드백 생성
  Future<Map<String, dynamic>> generateFeedback({
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      // 대화 내역 구성
      String conversationText = '=== 상담 대화 내역 ===\n';
      for (var message in conversationHistory) {
        final speaker = message['sender'] == 'user' ? '상담원' : 'AI 학생';
        conversationText += '$speaker: ${message['content']}\n';
      }

      String feedbackPrompt = '''
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

      // API 호출
      final response = await _dio.post(
        '/models/$_model:generateContent',
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': feedbackPrompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          }
        },
      );

      // 응답 파싱
      final candidates = response.data['candidates'] as List;
      if (candidates.isEmpty) {
        throw Exception('No response from Gemini API');
      }

      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      String text = parts[0]['text'] as String;

      // JSON 추출 (```json ... ``` 제거)
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

      // JSON 파싱
      final feedbackJson = jsonDecode(text) as Map<String, dynamic>;
      return feedbackJson;

    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
```

**완료 조건:**
- [ ] GeminiService 작성 완료
- [ ] 빌드 에러 없음

**예상 소요 시간**: 1시간

---

## Phase 6: Provider 구현 (1일)

### Step 6.1: ScenarioProvider 작성
**목표**: 시나리오 데이터 관리 Provider 구현

**작업 내용:**

**`lib/providers/scenario_provider.dart` 작성:**
```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scenario.dart';
import '../services/storage_service.dart';

// StorageService Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  final service = StorageService();
  // 초기화는 main.dart에서 수행
  return service;
});

// 시나리오 리스트 Provider
final scenariosProvider = FutureProvider<List<Scenario>>((ref) async {
  // JSON 파일에서 시나리오 로드
  final jsonString = await rootBundle.loadString('assets/scenarios/scenarios.json');
  final jsonList = jsonDecode(jsonString) as List;

  return jsonList.map((json) => Scenario.fromJson(json as Map<String, dynamic>)).toList();
});

// 특정 시나리오 Provider
final scenarioByIdProvider = Provider.family<AsyncValue<Scenario?>, String>((ref, scenarioId) {
  final scenariosAsync = ref.watch(scenariosProvider);

  return scenariosAsync.when(
    data: (scenarios) {
      try {
        final scenario = scenarios.firstWhere((s) => s.id == scenarioId);
        return AsyncValue.data(scenario);
      } catch (e) {
        return const AsyncValue.data(null);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

// 완료한 시나리오 개수 Provider
final completedScenarioCountProvider = Provider<int>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getCompletedScenarioCount();
});

// 시나리오 완료 여부 Provider
final isScenarioCompletedProvider = Provider.family<bool, String>((ref, scenarioId) {
  final storage = ref.watch(storageServiceProvider);
  return storage.isScenarioCompleted(scenarioId);
});
```

**완료 조건:**
- [ ] ScenarioProvider 작성 완료
- [ ] 빌드 에러 없음

**예상 소요 시간**: 30분

---

### Step 6.2: SessionProvider 작성
**목표**: 훈련 세션 관리 Provider 구현

**작업 내용:**

**`lib/providers/session_provider.dart` 작성:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/training_session.dart';
import '../models/chat_message.dart';
import '../models/feedback.dart' as model;
import 'scenario_provider.dart';

// 현재 활성 세션 Provider
final currentSessionProvider = StateNotifierProvider<CurrentSessionNotifier, TrainingSession?>((ref) {
  return CurrentSessionNotifier(ref);
});

class CurrentSessionNotifier extends StateNotifier<TrainingSession?> {
  final Ref ref;

  CurrentSessionNotifier(this.ref) : super(null);

  // 새 세션 시작
  void startSession(String scenarioId) {
    final uuid = const Uuid();
    state = TrainingSession(
      id: uuid.v4(),
      scenarioId: scenarioId,
      startTime: DateTime.now(),
      messages: [],
      isCompleted: false,
    );
  }

  // 메시지 추가
  void addMessage(ChatMessage message) {
    if (state == null) return;

    state = state!.copyWith(
      messages: [...state!.messages, message],
    );

    // 세션 자동 저장
    _saveSession();
  }

  // 세션 종료
  void endSession(model.Feedback feedback) {
    if (state == null) return;

    state = state!.copyWith(
      endTime: DateTime.now(),
      isCompleted: true,
      feedback: feedback,
    );

    // 최종 저장
    _saveSession();

    // 시나리오 완료 표시
    final storage = ref.read(storageServiceProvider);
    storage.markScenarioAsCompleted(state!.scenarioId);
  }

  // 세션 저장
  void _saveSession() {
    if (state == null) return;

    final storage = ref.read(storageServiceProvider);
    storage.saveSession(state!);
  }

  // 세션 초기화
  void clearSession() {
    state = null;
  }
}

// 모든 세션 Provider
final allSessionsProvider = Provider<List<TrainingSession>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getAllSessions();
});

// 완료된 세션만 Provider
final completedSessionsProvider = Provider<List<TrainingSession>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getCompletedSessions();
});
```

**완료 조건:**
- [ ] SessionProvider 작성 완료
- [ ] 빌드 에러 없음

**예상 소요 시간**: 40분

---

### Step 6.3: ChatProvider 작성
**목표**: 채팅 로직 관리 Provider 구현

**작업 내용:**

**`lib/providers/chat_provider.dart` 작성:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import 'session_provider.dart';
import 'scenario_provider.dart';

// GeminiService Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

// 채팅 상태 Provider
final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<void>>((ref) {
  return ChatNotifier(ref);
});

class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ChatNotifier(this.ref) : super(const AsyncValue.data(null));

  // 사용자 메시지 전송 및 AI 응답 받기
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;

    state = const AsyncValue.loading();

    try {
      final uuid = const Uuid();

      // 1. 사용자 메시지 추가
      final userMessage = ChatMessage(
        id: uuid.v4(),
        sessionId: currentSession.id,
        sender: 'user',
        content: content.trim(),
        timestamp: DateTime.now(),
      );

      ref.read(currentSessionProvider.notifier).addMessage(userMessage);

      // 2. AI 응답 생성
      final scenario = await _getCurrentScenario();
      if (scenario == null) {
        throw Exception('시나리오를 찾을 수 없습니다');
      }

      final gemini = ref.read(geminiServiceProvider);

      // 대화 히스토리 구성
      final conversationHistory = currentSession.messages.map((msg) {
        return {
          'sender': msg.sender,
          'content': msg.content,
        };
      }).toList();

      // AI 응답 생성
      final aiResponse = await gemini.generateAIResponse(
        systemPrompt: scenario.systemPrompt,
        conversationHistory: conversationHistory,
        userMessage: content,
      );

      // 3. AI 메시지 추가
      final aiMessage = ChatMessage(
        id: uuid.v4(),
        sessionId: currentSession.id,
        sender: 'ai',
        content: aiResponse,
        timestamp: DateTime.now(),
      );

      ref.read(currentSessionProvider.notifier).addMessage(aiMessage);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // 현재 시나리오 가져오기
  Future<dynamic> _getCurrentScenario() async {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return null;

    final scenariosAsync = ref.read(scenariosProvider);
    return scenariosAsync.when(
      data: (scenarios) {
        try {
          return scenarios.firstWhere((s) => s.id == currentSession.scenarioId);
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  // 피드백 생성
  Future<model.Feedback?> generateFeedback() async {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return null;

    state = const AsyncValue.loading();

    try {
      final gemini = ref.read(geminiServiceProvider);

      // 대화 히스토리 구성
      final conversationHistory = currentSession.messages.map((msg) {
        return {
          'sender': msg.sender,
          'content': msg.content,
        };
      }).toList();

      // 피드백 생성
      final feedbackData = await gemini.generateFeedback(
        conversationHistory: conversationHistory,
      );

      final uuid = const Uuid();
      final feedback = model.Feedback(
        id: uuid.v4(),
        sessionId: currentSession.id,
        scores: Map<String, int>.from(feedbackData['scores']),
        goodPoints: feedbackData['goodPoints'] as String,
        improvements: feedbackData['improvements'] as String,
        recommendedScenarios: List<String>.from(feedbackData['recommendedScenarios'] ?? []),
        createdAt: DateTime.now(),
      );

      state = const AsyncValue.data(null);
      return feedback;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}
```

**완료 조건:**
- [ ] ChatProvider 작성 완료
- [ ] 빌드 에러 없음

**예상 소요 시간**: 50분

---

### Step 6.4: main.dart에서 StorageService 초기화
**목표**: 앱 시작 시 StorageService 초기화

**작업 내용:**

**`lib/main.dart` 수정:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'providers/scenario_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Hive 초기화
  await Hive.initFlutter();

  // StorageService 초기화
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 상담 트레이닝',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('AI Psychiatry Training App'),
        ),
      ),
    );
  }
}
```

**완료 조건:**
- [ ] StorageService 초기화 완료
- [ ] 앱이 정상적으로 실행됨

**예상 소요 시간**: 15분

---

## Phase 7: 메인 화면 UI 구현 (1일)

### Step 7.1: ScenarioCard 위젯 작성
**목표**: 시나리오 카드 컴포넌트 구현

**작업 내용:**

**`lib/widgets/scenario_card.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import '../models/scenario.dart';
import '../core/constants/colors.dart';

class ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final bool isCompleted;
  final VoidCallback onTap;

  const ScenarioCard({
    super.key,
    required this.scenario,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      scenario.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  _buildDifficultyBadge(context),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                scenario.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${scenario.estimatedTime}분',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  if (isCompleted)
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '완료',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.success,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context) {
    Color color;
    String text;

    switch (scenario.difficulty) {
      case 'beginner':
        color = AppColors.success;
        text = '초급';
        break;
      case 'intermediate':
        color = AppColors.warning;
        text = '중급';
        break;
      case 'advanced':
        color = AppColors.error;
        text = '고급';
        break;
      default:
        color = AppColors.info;
        text = scenario.difficulty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
```

**완료 조건:**
- [ ] ScenarioCard 위젯 작성 완료
- [ ] 빌드 에러 없음

**예상 소요 시간**: 30분

---

### Step 7.2: HomeScreen 구현
**목표**: 메인 화면 UI 구현

**작업 내용:**

**`lib/screens/home/home_screen.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/scenario_provider.dart';
import '../../widgets/scenario_card.dart';
import '../../core/constants/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(scenariosProvider);
    final completedCount = ref.watch(completedScenarioCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 상담 트레이닝'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // 히스토리 화면으로 이동 (나중에 구현)
            },
          ),
        ],
      ),
      body: scenariosAsync.when(
        data: (scenarios) {
          final totalCount = scenarios.length;

          return Column(
            children: [
              // 진행도 표시
              _buildProgressSection(
                context,
                completedCount,
                totalCount,
              ),

              // 시나리오 리스트
              Expanded(
                child: scenarios.isEmpty
                    ? const Center(
                        child: Text('시나리오가 없습니다'),
                      )
                    : ListView.builder(
                        itemCount: scenarios.length,
                        itemBuilder: (context, index) {
                          final scenario = scenarios[index];
                          final isCompleted = ref.watch(
                            isScenarioCompletedProvider(scenario.id),
                          );

                          return ScenarioCard(
                            scenario: scenario,
                            isCompleted: isCompleted,
                            onTap: () {
                              // 시나리오 상세 화면으로 이동 (나중에 구현)
                              print('시나리오 선택: ${scenario.title}');
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text('오류가 발생했습니다\n$error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                '나의 진행도',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '완료: $completed/$total 시나리오 (${(progress * 100).toStringAsFixed(0)}%)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
```

**완료 조건:**
- [ ] HomeScreen 구현 완료
- [ ] 진행도 표시 정상 작동
- [ ] 시나리오 카드 리스트 표시됨

**예상 소요 시간**: 40분

---

### Step 7.3: main.dart에서 HomeScreen 연결
**목표**: 메인 화면을 앱의 홈으로 설정

**작업 내용:**

**`lib/main.dart` 수정:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'providers/scenario_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Hive 초기화
  await Hive.initFlutter();

  // StorageService 초기화
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 상담 트레이닝',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
```

**완료 조건:**
- [ ] HomeScreen이 앱의 첫 화면으로 표시됨
- [ ] 시나리오 리스트가 정상적으로 로드됨
- [ ] 진행도가 올바르게 표시됨

**예상 소요 시간**: 10분

---

## 체크포인트 1: Phase 1-7 완료 확인

**여기까지 완료하면 다음이 동작해야 합니다:**
- ✅ 앱 실행 시 메인 화면이 표시됨
- ✅ 3개의 시나리오가 카드 형태로 보임
- ✅ 진행도가 0/3으로 표시됨
- ✅ 난이도 배지가 올바르게 표시됨

**다음 Phase로 넘어가기 전에 반드시 확인하세요!**

---

## Phase 8: 시나리오 상세 화면 (반나절)

### Step 8.1: ScenarioDetailScreen 구현
**목표**: 시나리오 소개 화면 구현

**작업 내용:**

**`lib/screens/scenario_detail/scenario_detail_screen.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/scenario.dart';
import '../../providers/scenario_provider.dart';
import '../../providers/session_provider.dart';
import '../../core/constants/colors.dart';

class ScenarioDetailScreen extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDetailScreen({
    super.key,
    required this.scenarioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarioAsync = ref.watch(scenarioByIdProvider(scenarioId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('시나리오 정보'),
      ),
      body: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) {
            return const Center(
              child: Text('시나리오를 찾을 수 없습니다'),
            );
          }

          return _buildContent(context, ref, scenario);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('오류: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Scenario scenario) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Text(
                  scenario.title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                _buildMetaInfo(context, scenario),
                const Divider(height: 32),

                // 배경
                Text(
                  '배경',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  scenario.background,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // 학습 목표
                Text(
                  '학습 목표',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  scenario.learningGoals,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),

        // 시작 버튼
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () {
                // 세션 시작
                ref.read(currentSessionProvider.notifier).startSession(scenario.id);

                // 채팅 화면으로 이동 (나중에 구현)
                print('훈련 시작: ${scenario.title}');
              },
              child: const Text('훈련 시작'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaInfo(BuildContext context, Scenario scenario) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildInfoChip(
          context,
          icon: Icons.category,
          label: scenario.category,
        ),
        _buildInfoChip(
          context,
          icon: Icons.access_time,
          label: '${scenario.estimatedTime}분',
        ),
        _buildInfoChip(
          context,
          icon: Icons.signal_cellular_alt,
          label: _getDifficultyText(scenario.difficulty),
          color: _getDifficultyColor(scenario.difficulty),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: color ?? AppColors.primaryBlue,
      ),
      label: Text(label),
      backgroundColor: (color ?? AppColors.primaryBlue).withOpacity(0.1),
    );
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return '초급';
      case 'intermediate':
        return '중급';
      case 'advanced':
        return '고급';
      default:
        return difficulty;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }
}
```

**완료 조건:**
- [ ] ScenarioDetailScreen 구현 완료
- [ ] 시나리오 정보가 올바르게 표시됨
- [ ] "훈련 시작" 버튼이 동작함

**예상 소요 시간**: 1시간

---

## Phase 9: 채팅 화면 구현 (1-2일)

### Step 9.1: ChatBubble 위젯 작성
**목표**: 채팅 메시지 UI 컴포넌트 구현

**작업 내용:**

**`lib/widgets/chat_bubble.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';
import '../core/constants/colors.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isUser ? 64 : 16,
          right: isUser ? 16 : 64,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryBlue : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.primaryText,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _formatTime(message.timestamp),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
```

**pubspec.yaml에 패키지 추가:**
```yaml
dependencies:
  intl: ^0.18.0
```

**완료 조건:**
- [ ] ChatBubble 위젯 작성 완료
- [ ] intl 패키지 설치
- [ ] 빌드 에러 없음

**예상 소요 시간**: 30분

---

### Step 9.2: ChatScreen 구현
**목표**: 채팅 화면 UI 및 로직 구현

**작업 내용:**

**`lib/screens/chat/chat_screen.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/session_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/scenario_provider.dart';
import '../../widgets/chat_bubble.dart';
import '../../core/constants/colors.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isComposing = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSession = ref.watch(currentSessionProvider);
    final chatState = ref.watch(chatProvider);

    if (currentSession == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('채팅'),
        ),
        body: const Center(
          child: Text('세션이 없습니다'),
        ),
      );
    }

    final scenarioAsync = ref.watch(scenarioByIdProvider(currentSession.scenarioId));

    return Scaffold(
      appBar: AppBar(
        title: scenarioAsync.when(
          data: (scenario) => Text(scenario?.title ?? '채팅'),
          loading: () => const Text('로딩 중...'),
          error: (_, __) => const Text('채팅'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showEndDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 채팅 메시지 리스트
          Expanded(
            child: currentSession.messages.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: currentSession.messages.length,
                    itemBuilder: (context, index) {
                      final message = currentSession.messages[index];
                      return ChatBubble(message: message);
                    },
                  ),
          ),

          // 로딩 인디케이터
          if (chatState.isLoading)
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI 학생이 생각하고 있습니다...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                ],
              ),
            ),

          // 에러 표시
          if (chatState.hasError)
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.error.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.error, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '오류: ${chatState.error}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),

          // 입력 필드
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '첫 메시지를 보내보세요',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '학생과의 대화를 시작하세요.\n공감하며 이야기를 들어주는 것이 중요합니다.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.hintText,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isLoading = chatState.isLoading;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.trim().isNotEmpty;
                  });
                },
                onSubmitted: (_) => _handleSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.send,
                color: _isComposing && !isLoading
                    ? AppColors.primaryBlue
                    : AppColors.hintText,
              ),
              onPressed: _isComposing && !isLoading ? _handleSubmit : null,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // 메시지 전송
    ref.read(chatProvider.notifier).sendMessage(text);

    // 입력 필드 초기화
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });

    // 스크롤
    _scrollToBottom();
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대화 종료'),
        content: const Text('대화를 종료하시겠습니까?\n피드백을 받으실 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속하기'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // 다이얼로그 닫기

              // 피드백 생성
              final feedback = await ref.read(chatProvider.notifier).generateFeedback();

              if (feedback != null && mounted) {
                // 세션 종료
                ref.read(currentSessionProvider.notifier).endSession(feedback);

                // 피드백 화면으로 이동 (나중에 구현)
                print('피드백 생성 완료');
              }
            },
            child: const Text('종료하기'),
          ),
        ],
      ),
    );
  }
}
```

**완료 조건:**
- [ ] ChatScreen 구현 완료
- [ ] 메시지 전송 기능 동작
- [ ] AI 응답 받기 동작
- [ ] 대화 종료 다이얼로그 표시

**예상 소요 시간**: 2시간

---

## Phase 10: 피드백 화면 구현 (1일)

### Step 10.1: FeedbackScreen 구현
**목표**: 피드백 화면 UI 구현

**작업 내용:**

**`lib/screens/feedback/feedback_screen.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/training_session.dart';
import '../../core/constants/colors.dart';

class FeedbackScreen extends ConsumerWidget {
  final TrainingSession session;

  const FeedbackScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = session.feedback;

    if (feedback == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('피드백'),
        ),
        body: const Center(
          child: Text('피드백이 없습니다'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('훈련 완료'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 축하 메시지
            _buildCongratulationsCard(context),
            const SizedBox(height: 24),

            // 평가 점수
            Text(
              '평가 결과',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildScoresSection(context, feedback.scores),
            const SizedBox(height: 24),

            // 잘한 점
            Text(
              '잘한 점',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            _buildFeedbackCard(
              context,
              feedback.goodPoints,
              AppColors.success,
            ),
            const SizedBox(height: 24),

            // 개선할 점
            Text(
              '개선할 점',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            _buildFeedbackCard(
              context,
              feedback.improvements,
              AppColors.warning,
            ),
            const SizedBox(height: 32),

            // 버튼들
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCongratulationsCard(BuildContext context) {
    return Card(
      color: AppColors.primaryBlue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.celebration,
              size: 48,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '훈련 완료!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '수고하셨습니다',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoresSection(BuildContext context, Map<String, int> scores) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreRow(context, '공감 표현', scores['empathy'] ?? 0),
            const Divider(),
            _buildScoreRow(context, '경청 능력', scores['listening'] ?? 0),
            const Divider(),
            _buildScoreRow(context, '질문 적절성', scores['questioning'] ?? 0),
            const Divider(),
            _buildScoreRow(context, '해결책 제안', scores['solution'] ?? 0),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(BuildContext context, String label, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < score ? Icons.star : Icons.star_border,
                color: AppColors.warning,
                size: 24,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(BuildContext context, String content, Color accentColor) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: accentColor,
              width: 4,
            ),
          ),
        ),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // 메인 화면으로 이동
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('메인으로'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            // 같은 시나리오 다시 시작
            Navigator.of(context).popUntil((route) => route.isFirst);
            // ScenarioDetailScreen으로 이동 (나중에 구현)
          },
          child: const Text('다시 시도'),
        ),
      ],
    );
  }
}
```

**완료 조건:**
- [ ] FeedbackScreen 구현 완료
- [ ] 점수가 별로 표시됨
- [ ] 잘한 점/개선할 점 표시
- [ ] 버튼들이 동작함

**예상 소요 시간**: 1.5시간

---

## Phase 11: 히스토리 화면 구현 (반나절)

### Step 11.1: HistoryScreen 구현
**목표**: 과거 훈련 기록 화면 구현

**작업 내용:**

**`lib/screens/history/history_screen.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/session_provider.dart';
import '../../providers/scenario_provider.dart';
import '../../models/training_session.dart';
import '../../core/constants/colors.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(completedSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('훈련 기록'),
      ),
      body: sessions.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return _buildSessionCard(context, ref, session);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '훈련 기록이 없습니다',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 훈련을 시작해보세요!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.hintText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, WidgetRef ref, TrainingSession session) {
    final scenarioAsync = ref.watch(scenarioByIdProvider(session.scenarioId));
    final feedback = session.feedback;
    final averageScore = feedback?.averageScore ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // 피드백 화면으로 이동 (나중에 구현)
          print('세션 상세 보기: ${session.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: scenarioAsync.when(
                      data: (scenario) => Text(
                        scenario?.title ?? '시나리오',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      loading: () => const Text('로딩 중...'),
                      error: (_, __) => const Text('시나리오'),
                    ),
                  ),
                  _buildScoreBadge(context, averageScore),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(session.startTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.chat,
                    size: 14,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${session.messages.length}개 메시지',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge(BuildContext context, double score) {
    Color color;
    if (score >= 4.0) {
      color = AppColors.success;
    } else if (score >= 3.0) {
      color = AppColors.warning;
    } else {
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

**완료 조건:**
- [ ] HistoryScreen 구현 완료
- [ ] 완료된 세션 리스트 표시
- [ ] 평균 점수 배지 표시
- [ ] 빈 상태 표시

**예상 소요 시간**: 1시간

---

## Phase 12: 라우팅 및 통합 (1일)

### Step 12.1: AppRouter 작성
**목표**: Go Router를 사용한 화면 네비게이션 설정

**작업 내용:**

**`lib/core/router/app_router.dart` 작성:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/scenario_detail/scenario_detail_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/feedback/feedback_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../models/training_session.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 메인 화면
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // 시나리오 상세
    GoRoute(
      path: '/scenario/:id',
      builder: (context, state) {
        final scenarioId = state.pathParameters['id']!;
        return ScenarioDetailScreen(scenarioId: scenarioId);
      },
    ),

    // 채팅 화면
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),

    // 피드백 화면
    GoRoute(
      path: '/feedback',
      builder: (context, state) {
        final session = state.extra as TrainingSession;
        return FeedbackScreen(session: session);
      },
    ),

    // 히스토리 화면
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);
```

**완료 조건:**
- [ ] AppRouter 작성 완료
- [ ] 모든 화면 라우트 정의

**예상 소요 시간**: 30분

---

### Step 12.2: 모든 화면에 라우팅 연결
**목표**: 각 화면의 네비게이션 버튼에 실제 라우팅 연결

**작업 내용:**

**1. `lib/main.dart` 수정:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'services/storage_service.dart';
import 'providers/scenario_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Hive 초기화
  await Hive.initFlutter();

  // StorageService 초기화
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI 상담 트레이닝',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
```

**2. HomeScreen의 onTap 연결:**
```dart
// lib/screens/home/home_screen.dart
onTap: () {
  context.push('/scenario/${scenario.id}');
},

// 히스토리 버튼
IconButton(
  icon: const Icon(Icons.history),
  onPressed: () {
    context.push('/history');
  },
),
```

**3. ScenarioDetailScreen의 "훈련 시작" 버튼:**
```dart
onPressed: () {
  ref.read(currentSessionProvider.notifier).startSession(scenario.id);
  context.push('/chat');
},
```

**4. ChatScreen의 종료 다이얼로그:**
```dart
onPressed: () async {
  Navigator.pop(context); // 다이얼로그 닫기

  final feedback = await ref.read(chatProvider.notifier).generateFeedback();

  if (feedback != null && mounted) {
    ref.read(currentSessionProvider.notifier).endSession(feedback);

    final session = ref.read(currentSessionProvider);
    if (session != null) {
      context.go('/feedback', extra: session);
    }
  }
},
```

**5. FeedbackScreen의 버튼:**
```dart
// 메인으로 버튼
onPressed: () {
  ref.read(currentSessionProvider.notifier).clearSession();
  context.go('/');
},

// 다시 시도 버튼
onPressed: () {
  ref.read(currentSessionProvider.notifier).clearSession();
  context.go('/');
  // 또는 같은 시나리오로 이동
  // context.push('/scenario/${session.scenarioId}');
},
```

**6. HistoryScreen의 카드 클릭:**
```dart
onTap: () {
  context.push('/feedback', extra: session);
},
```

**완료 조건:**
- [ ] main.dart에서 GoRouter 사용
- [ ] 모든 화면 간 네비게이션 동작
- [ ] 뒤로 가기 동작 정상

**예상 소요 시간**: 1시간

---

## Phase 13: 테스트 및 버그 수정 (1-2일)

### Step 13.1: 전체 플로우 테스트
**목표**: 앱의 모든 기능 테스트

**테스트 항목:**

**1. 메인 화면**
- [ ] 앱 실행 시 메인 화면 표시
- [ ] 시나리오 3개가 카드로 표시됨
- [ ] 진행도가 0/3으로 표시됨
- [ ] 난이도 배지 정상 표시
- [ ] 히스토리 버튼 동작

**2. 시나리오 상세 화면**
- [ ] 시나리오 카드 클릭 시 상세 화면 이동
- [ ] 시나리오 정보 정상 표시
- [ ] "훈련 시작" 버튼 클릭 시 채팅 화면 이동

**3. 채팅 화면**
- [ ] 메시지 입력 및 전송 가능
- [ ] AI 응답이 정상적으로 표시됨
- [ ] 로딩 인디케이터 표시
- [ ] 스크롤이 자동으로 하단으로 이동
- [ ] 종료 다이얼로그 표시
- [ ] 피드백 생성 및 화면 이동

**4. 피드백 화면**
- [ ] 점수가 별로 표시됨
- [ ] 잘한 점/개선할 점 표시
- [ ] "메인으로" 버튼 동작
- [ ] "다시 시도" 버튼 동작

**5. 히스토리 화면**
- [ ] 완료된 세션 리스트 표시
- [ ] 빈 상태 표시
- [ ] 세션 클릭 시 피드백 화면 이동

**6. 데이터 저장**
- [ ] 대화 중 앱 종료 후 재실행 시 데이터 유지
- [ ] 완료한 시나리오가 표시됨
- [ ] 진행도가 올바르게 업데이트됨

**예상 소요 시간**: 2시간

---

### Step 13.2: 버그 수정 및 개선
**목표**: 발견된 버그 수정 및 UX 개선

**체크리스트:**
- [ ] 에러 처리 강화
- [ ] 로딩 상태 개선
- [ ] 네트워크 오류 시 재시도 기능
- [ ] UI 버그 수정
- [ ] 성능 최적화
- [ ] 코드 정리 및 주석 추가

**예상 소요 시간**: 4시간

---

### Step 13.3: Gemini API 키 입력 및 테스트
**목표**: 실제 API 키로 통합 테스트

**작업 내용:**

1. `.env` 파일에 실제 Gemini API 키 입력:
```
GEMINI_API_KEY=실제_API_키_입력
```

2. 실제 AI 대화 테스트:
- [ ] AI 응답이 자연스러운지 확인
- [ ] 시나리오별로 캐릭터가 다르게 반응하는지 확인
- [ ] 피드백이 정확한지 확인

3. API 오류 처리 테스트:
- [ ] 네트워크 끊김 시
- [ ] API 키 오류 시
- [ ] 타임아웃 시

**예상 소요 시간**: 1시간

---

## 최종 체크리스트

**모든 기능이 정상 작동하는지 확인:**

### 필수 기능
- [ ] 시나리오 리스트 표시
- [ ] 시나리오 선택 및 상세 보기
- [ ] AI와 실시간 대화
- [ ] 대화 종료 및 피드백 받기
- [ ] 훈련 기록 보기
- [ ] 로컬 저장소에 데이터 저장

### UI/UX
- [ ] 깔끔하고 직관적인 UI
- [ ] Material Design 3 테마 적용
- [ ] 로딩 상태 표시
- [ ] 에러 메시지 표시

### 성능
- [ ] AI 응답 시간 3초 이내
- [ ] 화면 전환 부드러움
- [ ] 메모리 누수 없음

---

## 완료!

**축하합니다! MVP 개발이 완료되었습니다!**

**최종 확인:**
1. 앱을 처음부터 끝까지 사용해보기
2. 다양한 시나리오 테스트
3. 여러 번 대화 후 히스토리 확인
4. 데이터 저장 및 복원 확인

**다음 단계 (선택 사항):**
- 앱 아이콘 및 스플래시 스크린 추가
- 앱 배포 준비 (Android APK/AAB, iOS IPA)
- 사용자 피드백 수집
- 추가 시나리오 작성

---

## 추가 도움말

**자주 발생하는 문제:**

1. **Gemini API 응답 안 됨**
   - API 키가 올바른지 확인
   - 인터넷 연결 확인
   - API 할당량 확인

2. **빌드 에러**
   - `flutter clean` 실행
   - `flutter pub get` 재실행
   - `flutter pub run build_runner build --delete-conflicting-outputs`

3. **데이터 저장 안 됨**
   - StorageService 초기화 확인
   - Hive box가 열렸는지 확인

4. **화면 전환 안 됨**
   - GoRouter 설정 확인
   - context.push 경로 확인

**문의 사항이 있으면 언제든지 질문하세요!**
