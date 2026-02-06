import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
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

    // Auto-scroll when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

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
          if (chatState.isLoading)
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const SizedBox(
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

    ref.read(chatProvider.notifier).sendMessage(text);

    _messageController.clear();
    setState(() {
      _isComposing = false;
    });

    _scrollToBottom();
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('대화 종료'),
        content: const Text('대화를 종료하시겠습니까?\n피드백을 받으실 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('계속하기'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final feedback = await ref.read(chatProvider.notifier).generateFeedback();

              if (feedback != null && mounted) {
                ref.read(currentSessionProvider.notifier).endSession(feedback);

                final session = ref.read(currentSessionProvider);
                if (session != null) {
                  context.go('/feedback', extra: session);
                }
              }
            },
            child: const Text('종료하기'),
          ),
        ],
      ),
    );
  }
}
