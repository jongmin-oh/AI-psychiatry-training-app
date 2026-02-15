# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI-powered psychiatry peer counseling training application built with Flutter. The app simulates counseling scenarios where users (trainee counselors) practice their counseling skills by interacting with AI-powered student characters that respond realistically to counseling techniques. Each session is evaluated and feedback is provided using Google Gemini AI.

## Common Development Commands

### Running the app
```bash
flutter run
```

### Code generation
After modifying models with `@JsonSerializable` annotations:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running tests
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

## Architecture

### State Management - Riverpod Pattern

The app uses flutter_riverpod for state management. Key providers:

- **currentSessionProvider**: Manages the active training session (StateNotifierProvider)
- **scenariosProvider**: Loads scenarios from JSON assets (FutureProvider)
- **chatProvider**: Handles chat message sending and AI response generation (StateNotifierProvider)
- **storageServiceProvider**: Provides access to local storage service (Provider)

When working with providers:
- Use `ref.read()` for one-time access in event handlers
- Use `ref.watch()` for reactive rebuilds in widgets
- Prefer NotifierProvider and AsyncNotifierProvider over StateProvider
- Use `ref.invalidate()` to manually trigger provider updates

### Core Data Flow

1. **Scenario Selection** (HomeScreen) → User selects a training scenario
2. **Session Initialization** (ScenarioDetailScreen) → Creates TrainingSession with random AI greeting
3. **Chat Interaction** (ChatScreen) → User sends messages, AI responds via GeminiService
4. **Session Completion** → AI generates feedback, session saved with StorageService
5. **History Review** (HistoryScreen) → View past sessions and feedback

### Models & JSON Serialization

All models use `json_annotation` with `@JsonSerializable()`:
- `Scenario`: Training scenario configuration loaded from assets/scenarios/scenarios.json
- `TrainingSession`: Represents a counseling practice session
- `ChatMessage`: Individual message in a conversation
- `Feedback`: AI-generated evaluation of counseling performance

The Scenario model includes:
- `exampleDialogue`: List of example turns to guide AI behavior
- `systemPrompt`: Instructions for AI to role-play as the student character
- `greetings`: Array of possible opening messages (randomly selected)
- `getRandomGreeting()`: Method to select a random greeting

After modifying any model, run code generation to update `.g.dart` files.

### Services

**GeminiService** (lib/services/gemini_service.dart):
- Communicates with Google Gemini API (gemini-flash-latest model)
- `generateAIResponse()`: Multi-turn conversation with system prompt + conversation history + example dialogue
- `generateFeedback()`: Analyzes full conversation and returns structured JSON feedback
- API key loaded from `.env` file via flutter_dotenv
- Response is truncated to 200 characters max (preserving sentence boundaries)

**StorageService** (lib/services/storage_service.dart):
- Uses Hive for session storage and SharedPreferences for scenario completion tracking
- `saveSession()` / `getSession()`: Persist/retrieve TrainingSession objects as JSON
- `getAllSessions()`: Returns all sessions sorted by start time (newest first)
- `markScenarioAsCompleted()`: Tracks which scenarios have been completed
- Must call `init()` before use (called in main.dart)

### Navigation with GoRouter

Router configuration in lib/core/router/app_router.dart:

- Uses StatefulShellRoute with indexed stack for bottom navigation (3 tabs):
  - `/scenarios` (HomeScreen): Browse available scenarios
  - `/counseling` (CounselingScreen): Counseling-related content
  - `/history` (HistoryScreen): View past training sessions

- Full-screen routes (use rootNavigatorKey):
  - `/scenario/:id` (ScenarioDetailScreen): Scenario details and start button
  - `/chat` (ChatScreen): Active counseling conversation
  - `/feedback` (FeedbackScreen): Post-session AI feedback (requires TrainingSession via extra)
  - `/conversation-history` (ConversationHistoryScreen): View conversation messages (requires List<ChatMessage> via extra)

When navigating to `/feedback` or `/conversation-history`, pass data via `extra` parameter.

### Environment Configuration

Create a `.env` file in the project root with:
```
GEMINI_API_KEY=your_api_key_here
```

The app loads this in main.dart using `flutter_dotenv`.

## Development Guidelines

### Flutter & Dart Conventions
- Use `const` constructors for immutable widgets
- Prefer expression bodies (`=>`) for simple functions and getters
- Always include trailing commas for better formatting
- Line length: 80 characters max

### Error Handling
- Use `SelectableText.rich` with red color for visible error display (not SnackBar)
- Handle AsyncValue states properly: loading, data, error
- Display empty states inline within screens

### Widget Structure
- Create small private widget classes instead of `Widget _build...` methods
- Prefer stateless widgets with ConsumerWidget for Riverpod integration
- Use const widgets where possible to optimize rebuilds

### Scenario JSON Structure

Scenarios are defined in assets/scenarios/scenarios.json with this structure:
```json
{
  "id": "scenario_001",
  "title": "시험 불안",
  "description": "...",
  "difficulty": "beginner|intermediate|advanced",
  "estimatedTime": 15,
  "category": "학업 스트레스",
  "background": "...",
  "learningGoals": "...",
  "greetings": ["안녕하세요...", "..."],
  "exampleDialogue": [
    {"sender": "student", "message": "..."},
    {"sender": "counselor", "message": "..."}
  ],
  "systemPrompt": "...",
  "characterProfile": {...}
}
```

The `exampleDialogue` is appended to the systemPrompt when generating AI responses to provide context for natural conversation flow.

## Code Quality

- Run `flutter analyze` before committing
- Debug using `log()` from dart:developer (not `print()`)
- Follow the official Flutter, Riverpod documentation for best practices
