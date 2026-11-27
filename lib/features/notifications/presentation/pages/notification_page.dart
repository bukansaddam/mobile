import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_card.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_error_view.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_navigation_helper.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Halaman daftar notifikasi terintegrasi API (`GET /api/notifications`).
class NotificationPage extends StatefulWidget {
  final ValueChanged<AppNotificationEntity>? onTapOverride;

  const NotificationPage({super.key, this.onTapOverride});

  static Future<void> show(BuildContext context) {
    NotificationBloc? existingBloc;
    try {
      existingBloc = context.read<NotificationBloc>();
    } catch (_) {
      existingBloc = null;
    }

    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => existingBloc != null
            ? BlocProvider<NotificationBloc>.value(
                value: existingBloc,
                child: const NotificationPage(),
              )
            : BlocProvider<NotificationBloc>(
                create: (_) => sl<NotificationBloc>(),
                child: const NotificationPage(),
              ),
      ),
    );
  }

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationBloc>().add(
        const FetchNotificationsEvent(isRefresh: true, unreadOnly: false),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<NotificationBloc>().add(const LoadMoreNotificationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppPageBar(title: 'Notifikasi'),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listenWhen: (prev, curr) =>
            prev.actionErrorMessage != curr.actionErrorMessage &&
            curr.actionErrorMessage != null,
        listener: (context, state) {
          final message = state.actionErrorMessage;
          if (message != null && message.isNotEmpty) {
            AppToast.showError(context, message: message);
            context.read<NotificationBloc>().add(
              const ClearNotificationActionErrorEvent(),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<NotificationBloc>();

          if (state.isLoading && state.items.isEmpty) {
            return const ReportCardShimmerList(itemCount: 5);
          }
          if (state.errorMessage != null && state.items.isEmpty) {
            return NotificationErrorView(
              message: state.errorMessage!,
              onRetry: () => bloc.add(const FetchNotificationsEvent()),
            );
          }
          return RefreshIndicator(
            color: colors.primaryDark,
            onRefresh: () async {
              bloc.add(const FetchNotificationsEvent(isRefresh: true));
              await bloc.stream
                  .firstWhere((next) => !next.isRefreshing && !next.isLoading)
                  .timeout(
                    const Duration(seconds: 5),
                    onTimeout: () => bloc.state,
                  );
            },
            child: state.items.isEmpty
                ? NotificationEmptyView(
                    unreadOnlyFilter: state.unreadOnlyFilter,
                    onShowAll: state.unreadOnlyFilter
                        ? () => bloc.add(
                            const FetchNotificationsEvent(
                              isRefresh: true,
                              unreadOnly: false,
                            ),
                          )
                        : null,
                  )
                : ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount:
                        state.items.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colors.primaryDark,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }

                      final item = state.items[index];
                      return NotificationCard(
                        item: item,
                        onTap: () {
                          if (widget.onTapOverride != null) {
                            widget.onTapOverride!(item);
                            return;
                          }
                          NotificationNavigationHelper.handleNotificationTap(
                            context,
                            item,
                          );
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
