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
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/scenario/:id',
      builder: (context, state) {
        final scenarioId = state.pathParameters['id']!;
        return ScenarioDetailScreen(scenarioId: scenarioId);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/feedback',
      builder: (context, state) {
        final session = state.extra as TrainingSession;
        return FeedbackScreen(session: session);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);
