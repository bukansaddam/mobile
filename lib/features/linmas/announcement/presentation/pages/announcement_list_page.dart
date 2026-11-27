import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_state.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/announcement_detail_modal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _buildListImage(BuildContext context, String path) {
  final colors = context.appColors;
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return AppNetworkImage(
      imageUrl: path,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      errorIcon: Icons.campaign_outlined,
      backgroundColor: colors.primaryLight,
    );
  }
  return Image.asset(
    path,
    width: 52,
    height: 52,
    cacheWidth: 156,
    cacheHeight: 156,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      width: 52,
      height: 52,
      color: colors.primaryLight,
      child: Icon(Icons.campaign_outlined, color: colors.primary, size: 24),
    ),
  );
}

class AnnouncementListPage extends StatelessWidget {
  const AnnouncementListPage({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnnouncementListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AnnouncementBloc>()..add(const FetchAnnouncements()),
      child: const AnnouncementListView(),
    );
  }
}

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({super.key});

  @override
  State<AnnouncementListView> createState() => _AnnouncementListViewState();
}

class _AnnouncementListViewState extends State<AnnouncementListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }

    final bloc = context.read<AnnouncementBloc>();
    if (bloc.state.isLoadingMore || bloc.state.hasReachedMax) return;
    bloc.add(const LoadMoreAnnouncements());
  }

  Future<void> _onRefresh() async {
    context.read<AnnouncementBloc>().add(
      const FetchAnnouncements(isRefresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppPageBar(title: 'Pengumuman'),
      body: BlocBuilder<AnnouncementBloc, AnnouncementState>(
        builder: (context, state) {
          if (state.status == AnnouncementStatus.loading &&
              state.announcements.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          if (state.status == AnnouncementStatus.error &&
              state.announcements.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: colors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Gagal memuat pengumuman',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<AnnouncementBloc>().add(
                          const FetchAnnouncements(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.announcements.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: colors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            size: 48,
                            color: colors.textHint,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada pengumuman',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: colors.primary,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.announcements.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.announcements.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  );
                }

                final item = state.announcements[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      onTap: () => AnnouncementDetailModal.show(context, item),
                      leading: item.hasImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _buildListImage(
                                context,
                                item.allImages.first,
                              ),
                            )
                          : Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: colors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.campaign_outlined,
                                color: colors.primary,
                                size: 24,
                              ),
                            ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.textSecondary,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (item.date.isNotEmpty) ...[
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 11,
                                    color: colors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.date,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: colors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: colors.textHint,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
