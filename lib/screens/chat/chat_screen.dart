import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/training_session.dart';
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
  final FocusNode _messageFocusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    // 첫 프레임 렌더 후 포커스 요청 → 가상 키보드 표시 (iOS/Android)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _messageFocusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  /// reverse: true이므로 minScrollExtent(0)가 새 메시지 쪽(맨 아래)
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
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
        appBar: AppBar(title: const Text('채팅')),
        body: const Center(child: Text('세션이 없습니다')),
      );
    }

    // Auto-scroll when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final scenarioAsync = ref.watch(
      scenarioByIdProvider(currentSession.scenarioId),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: '나가기',
          onPressed: () => _showExitDialog(context),
        ),
        title: scenarioAsync.when(
          data: (scenario) => Text(scenario?.title ?? '채팅'),
          loading: () => const Text('로딩 중...'),
          error: (_, __) => const Text('채팅'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: '상담 종료하기',
            onPressed: () => _showEndDialog(context, currentSession),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 뒤: 채팅 목록만 터치 시 unfocus (입력 영역과 겹치지 않도록 영역 분리)
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: currentSession.messages.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            // reverse이므로 bottom 패딩이 새 메시지 쪽(화면 하단) 여백
                            padding: const EdgeInsets.only(top: 16, bottom: 88),
                            itemCount: currentSession.messages.length,
                            itemBuilder: (context, index) {
                              final message =
                                  currentSession.messages[currentSession
                                          .messages
                                          .length -
                                      1 -
                                      index];
                              return ChatBubble(message: message);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          // 앞: 입력 영역을 맨 위에 올려 전송 버튼 탭이 GestureDetector에 잡히지 않도록
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AI 학생이 생각하고 있습니다...',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.secondaryText),
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
                        const Icon(
                          Icons.error,
                          color: AppColors.error,
                          size: 20,
                        ),
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
          ),
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
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '학생과의 대화를 시작하세요.\n공감하며 이야기를 들어주는 것이 중요합니다.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.hintText),
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
                focusNode: _messageFocusNode,
                autofocus: false,
                readOnly: false,
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
            // 포커스를 받지 않아 전송 시에도 TextField 포커스 유지 → 키보드 유지
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _isComposing && !isLoading ? _handleSubmit : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.send,
                    color: _isComposing && !isLoading
                        ? AppColors.primaryBlue
                        : AppColors.hintText,
                  ),
                ),
              ),
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
    setState(() => _isComposing = false);

    _scrollToBottom();

    // 포커스 유지/복구: 즉시 1회 + 키보드 프레임 이후 1회 (기기별 안정성)
    _messageFocusNode.requestFocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) _messageFocusNode.requestFocus();
    });
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('상담 나가기'),
        content: const Text('상담에서 나가시겠습니까?\n나중에 상담 탭에서 이어할 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('계속하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(currentSessionProvider.notifier).clearSession();
              context.go('/counseling');
            },
            child: const Text('나가기'),
          ),
        ],
      ),
    );
  }

  /// 상담 종료 시 최소 필요한 대화 횟수 (1회 = 사용자 메시지 1개 + AI 응답 1개)
  static const int _minimumExchangeCount = 5;

  void _showEndDialog(BuildContext context, TrainingSession currentSession) {
    final userMessageCount = currentSession.messages
        .where((m) => m.isUser)
        .length;

    if (userMessageCount < _minimumExchangeCount) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('상담 종료 불가'),
          content: Text(
            '학생과 $_minimumExchangeCount번 이상 대화를 나눈 후 '
            '상담을 종료할 수 있습니다. (현재 $userMessageCount/$_minimumExchangeCount회)',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

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

              final feedback = await ref
                  .read(chatProvider.notifier)
                  .generateFeedback();

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
