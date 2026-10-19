import 'package:equatable/equatable.dart';

class AnnouncementItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String date;
  final String author;
  final String? imagePath;
  final List<String> images;
  final bool isPinned;

  const AnnouncementItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.date,
    required this.author,
    this.imagePath,
    this.images = const [],
    this.isPinned = false,
  });

  List<String> get allImages {
    if (images.isNotEmpty) return images;
    if (imagePath != null && imagePath!.isNotEmpty) return [imagePath!];
    return [];
  }

  bool get hasImage => allImages.isNotEmpty;

  bool get isPenting => isPinned;

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    content,
    date,
    author,
    imagePath,
    images,
    isPinned,
  ];
}
