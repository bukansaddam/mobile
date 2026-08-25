import 'package:equatable/equatable.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object?> get props => [];
}

class FetchAnnouncements extends AnnouncementEvent {
  final String? category;
  final bool? isPinned;
  final bool isRefresh;

  const FetchAnnouncements({
    this.category,
    this.isPinned,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [category, isPinned, isRefresh];
}

class FetchBannerAnnouncements extends AnnouncementEvent {
  final String? category;

  const FetchBannerAnnouncements({this.category});

  @override
  List<Object?> get props => [category];
}

class LoadMoreAnnouncements extends AnnouncementEvent {
  const LoadMoreAnnouncements();
}
