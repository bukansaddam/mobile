import 'dart:async';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_event.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_state.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom sheet daftar sesi riwayat Asisten AI Siska (pencarian debounce 500ms, rename, dan hapus).
class AiChatSessionsSheet extends StatefulWidget {
  const AiChatSessionsSheet({super.key});

  @override
  State<AiChatSessionsSheet> createState() => _AiChatSessionsSheetState();
}

class _AiChatSessionsSheetState extends State<AiChatSessionsSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<AiChatBloc>().add(const LoadAiChatSessionsEvent());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<AiChatBloc>().add(LoadAiChatSessionsEvent(search: query));
    });
  }

  Future<void> _showRenameDialog(AiChatSessionEntity session) async {
    final controller = TextEditingController(text: session.title);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ubah Judul Percakapan'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Masukkan judul baru'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result != null && result.trim().isNotEmpty && mounted) {
      context.read<AiChatBloc>().add(
        RenameAiChatSessionEvent(sessionId: session.id, title: result.trim()),
      );
    }
  }

  Future<void> _confirmDelete(AiChatSessionEntity session) async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus Riwayat Chat?',
      message:
          'Percakapan "${session.title}" akan dihapus permanen dan tidak bisa dikembalikan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      context.read<AiChatBloc>().add(DeleteAiChatSessionEvent(session.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Riwayat Percakapan',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<AiChatBloc>().add(
                          const StartNewAiChatSessionEvent(),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Baru'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari riwayat percakapan...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    isDense: true,
                    filled: true,
                    fillColor: colors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<AiChatBloc, AiChatState>(
                  builder: (context, state) {
                    if (state.isLoadingSessions && state.sessions.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.sessions.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Belum ada riwayat percakapan.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: state.sessions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final session = state.sessions[index];
                        final isSelected =
                            state.activeSession?.id == session.id;
                        return Material(
                          color: isSelected
                              ? colors.primaryLight
                              : colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? colors.primaryBorder
                                    : colors.border,
                              ),
                            ),
                            title: Text(
                              session.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            onTap: () {
                              context.read<AiChatBloc>().add(
                                SelectAiChatSessionEvent(session.id),
                              );
                              Navigator.pop(context);
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: colors.textSecondary,
                                  ),
                                  tooltip: 'Ubah judul',
                                  onPressed: () => _showRenameDialog(session),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: colors.error,
                                  ),
                                  tooltip: 'Hapus sesi',
                                  onPressed: () => _confirmDelete(session),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
