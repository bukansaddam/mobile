import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_event.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_state.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_avatar.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_empty_view.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_input_bar.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_message_bubble.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_sessions_sheet.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Layar utama percakapan dengan Asisten AI Siska (mendukung multi-role Linmas & Dumas).
class AiChatPage extends StatefulWidget {
  final bool? isOfficerOverride;

  const AiChatPage({super.key, this.isOfficerOverride});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _resolveIsOfficer(BuildContext context) {
    if (widget.isOfficerOverride != null) {
      return widget.isOfficerOverride!;
    }
    try {
      return context.select<AuthBloc, bool?>(
            (bloc) => bloc.state.user?.isOfficer,
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  void _sendCurrentInput() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    context.read<AiChatBloc>().add(SendAiChatMessageEvent(text));
    _scrollToBottom();
  }

  void _sendQuickPrompt(String prompt) {
    context.read<AiChatBloc>().add(SendAiChatMessageEvent(prompt));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _openSessionsSheet() {
    final bloc = context.read<AiChatBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider<AiChatBloc>.value(
        value: bloc,
        child: const AiChatSessionsSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isOfficer = _resolveIsOfficer(context);

    return BlocConsumer<AiChatBloc, AiChatState>(
      listenWhen: (prev, curr) => prev.messages.length != curr.messages.length,
      listener: (_, _) => _scrollToBottom(),
      builder: (context, state) {
        final bannerText = state.isOffline
            ? 'Sedang offline. Riwayat yang termuat tetap dapat dibaca, pengiriman pesan dinonaktifkan.'
            : (!state.isEnabled
                  ? (state.disabledMessage ??
                        'Layanan Asisten AI Siska sedang dinonaktifkan sementara.')
                  : null);

        return Scaffold(
          appBar: AppPageBar(
            title: state.activeSession?.title ?? 'Asisten AI Siska',
            actions: [
              IconButton(
                tooltip: 'Riwayat chat',
                onPressed: _openSessionsSheet,
                icon: Icon(Icons.history_rounded, color: colors.textPrimary),
              ),
              IconButton(
                tooltip: 'Obrolan baru',
                onPressed: () => context.read<AiChatBloc>().add(
                  const StartNewAiChatSessionEvent(),
                ),
                icon: Icon(
                  Icons.add_comment_outlined,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (bannerText != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  color: state.isOffline
                      ? colors.warningLight
                      : colors.errorLight,
                  child: Row(
                    children: [
                      Icon(
                        state.isOffline
                            ? Icons.wifi_off_rounded
                            : Icons.info_outline_rounded,
                        size: 18,
                        color: state.isOffline
                            ? colors.warningDark
                            : colors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bannerText,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: state.isOffline
                                ? colors.warningDark
                                : colors.errorDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  color: colors.errorLight,
                  child: Text(
                    state.errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.errorDark,
                    ),
                  ),
                ),
              Expanded(
                child: state.isLoadingSession
                    ? const Center(child: CircularProgressIndicator())
                    : state.messages.isEmpty
                    ? AiChatEmptyView(
                        isOfficer: isOfficer,
                        canSend: state.canSend,
                        onSelectPrompt: _sendQuickPrompt,
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        itemCount:
                            state.messages.length +
                            (state.nextBeforeId != null ? 1 : 0) +
                            (state.isSending ? 1 : 0),
                        itemBuilder: (context, index) {
                          var cursor = index;
                          if (state.nextBeforeId != null) {
                            if (cursor == 0) {
                              return Center(
                                child: TextButton(
                                  onPressed: state.isLoadingMore
                                      ? null
                                      : () => context.read<AiChatBloc>().add(
                                          const LoadMoreAiChatMessagesEvent(),
                                        ),
                                  child: Text(
                                    state.isLoadingMore
                                        ? 'Memuat pesan lama...'
                                        : 'Muat pesan lebih lama',
                                  ),
                                ),
                              );
                            }
                            cursor -= 1;
                          }

                          if (cursor < state.messages.length) {
                            final msg = state.messages[cursor];
                            return AiChatMessageBubble(
                              message: msg,
                              onRetry: msg.localId != null
                                  ? () => context.read<AiChatBloc>().add(
                                      RetryFailedAiChatMessageEvent(
                                        msg.localId!,
                                      ),
                                    )
                                  : null,
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const AiChatAvatar(size: 20),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Siska sedang mengetik...',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              AiChatInputBar(
                controller: _inputController,
                canSend: state.canSend,
                isSending: state.isSending,
                isEnabled: state.isEnabled,
                isOffline: state.isOffline,
                onSend: _sendCurrentInput,
              ),
            ],
          ),
        );
      },
    );
  }
}
