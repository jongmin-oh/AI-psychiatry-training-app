import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_session.dart';

class StorageService {
  static const String _sessionsBoxName = 'training_sessions';
  static const String _completedScenariosKey = 'completed_scenarios';

  late Box<String> _sessionsBox;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _sessionsBox = await Hive.openBox<String>(_sessionsBoxName);
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveSession(TrainingSession session) async {
    final jsonString = jsonEncode(session.toJson());
    await _sessionsBox.put(session.id, jsonString);
  }

  TrainingSession? getSession(String sessionId) {
    final jsonString = _sessionsBox.get(sessionId);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return TrainingSession.fromJson(json);
  }

  List<TrainingSession> getAllSessions() {
    final sessions = <TrainingSession>[];

    for (var key in _sessionsBox.keys) {
      final jsonString = _sessionsBox.get(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        sessions.add(TrainingSession.fromJson(json));
      }
    }

    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  List<TrainingSession> getCompletedSessions() {
    return getAllSessions().where((s) => s.isCompleted).toList();
  }

  List<TrainingSession> getActiveSessions() {
    return getAllSessions().where((s) => !s.isCompleted).toList();
  }

  bool isScenarioCompleted(String scenarioId) {
    final completedIds = _prefs.getStringList(_completedScenariosKey) ?? [];
    return completedIds.contains(scenarioId);
  }

  Future<void> markScenarioAsCompleted(String scenarioId) async {
    final completedIds = _prefs.getStringList(_completedScenariosKey) ?? [];
    if (!completedIds.contains(scenarioId)) {
      completedIds.add(scenarioId);
      await _prefs.setStringList(_completedScenariosKey, completedIds);
    }
  }

  int getCompletedScenarioCount() {
    return _prefs.getStringList(_completedScenariosKey)?.length ?? 0;
  }

  Future<void> deleteSession(String sessionId) async {
    await _sessionsBox.delete(sessionId);
  }

  Future<void> clearAll() async {
    await _sessionsBox.clear();
    await _prefs.clear();
  }
}
