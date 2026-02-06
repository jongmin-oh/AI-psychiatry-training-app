import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scenario.dart';
import '../services/storage_service.dart';

// StorageService Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  final service = StorageService();
  return service;
});

// Scenario list Provider
final scenariosProvider = FutureProvider<List<Scenario>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/scenarios/scenarios.json');
  final jsonList = jsonDecode(jsonString) as List;

  return jsonList.map((json) => Scenario.fromJson(json as Map<String, dynamic>)).toList();
});

// Scenario by ID Provider
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

// Completed scenario count Provider
final completedScenarioCountProvider = Provider<int>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getCompletedScenarioCount();
});

// Scenario completed status Provider
final isScenarioCompletedProvider = Provider.family<bool, String>((ref, scenarioId) {
  final storage = ref.watch(storageServiceProvider);
  return storage.isScenarioCompleted(scenarioId);
});
