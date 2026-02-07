import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/main/main_shell.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/scenario_detail/scenario_detail_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/feedback/feedback_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../models/training_session.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/scenarios',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scenarios',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/scenario/:id',
      builder: (context, state) {
        final scenarioId = state.pathParameters['id']!;
        return ScenarioDetailScreen(scenarioId: scenarioId);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/feedback',
      builder: (context, state) {
        final session = state.extra as TrainingSession;
        return FeedbackScreen(session: session);
      },
    ),
  ],
);
