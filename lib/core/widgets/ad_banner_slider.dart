import 'dart:async';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:flutter/material.dart';

class BannerItem {
  final String imagePath;
  final String title;
  final String? subtitle;

  const BannerItem({
    required this.imagePath,
    required this.title,
    this.subtitle,
  });
}

class AdBannerSlider extends StatefulWidget {
  final List<BannerItem>? items;
  final Duration autoPlayDuration;
  final double height;

  const AdBannerSlider({
    super.key,
    this.items,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.height = 170.0,
  });

  @override
  State<AdBannerSlider> createState() => _AdBannerSliderState();
}

class _AdBannerSliderState extends State<AdBannerSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  late final List<BannerItem> _bannerItems;

  @override
  void initState() {
    super.initState();
    _bannerItems =
        widget.items ??
        const [
          BannerItem(
            imagePath: 'assets/banner_1.jpg',
            title: 'Gerakan Kota Bersih & Hijau',
            subtitle: 'Mari sukseskan program lingkungan sehat bersama!',
          ),
          BannerItem(
            imagePath: 'assets/banner_2.jpg',
            title: 'Layanan Pengaduan Cepat',
            subtitle: 'Laporkan masalah di sekitar Anda secara real-time.',
          ),
          BannerItem(
            imagePath: 'assets/banner_illustration.jpg',
            title: 'Informasi Layanan Publik',
            subtitle: 'Tingkatkan kenyamanan lingkungan masyarakat.',
          ),
        ];

    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (_bannerItems.length <= 1) return;

    _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _bannerItems.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreen(int index) {
    final imagePaths = _bannerItems.map((e) => e.imagePath).toList();
    FullscreenImageViewer.show(
      context,
      imagePathOrUrl: imagePaths[index],
      images: imagePaths,
      initialIndex: index,
      title: _bannerItems[index].title,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerItems.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _bannerItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector(
                  onTap: () => _openFullscreen(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primaryLight,
                                child: const Center(
                                  child: Icon(
                                    Icons.campaign_outlined,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),

                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withAlpha(40),
                                    Colors.black.withAlpha(210),
                                  ],
                                  stops: const [0.0, 0.35, 1.0],
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(220),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.campaign_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'IKLAN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 12,
                            left: 14,
                            right: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black87,
                                        blurRadius: 6,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(240),
                                      fontSize: 12,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black87,
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        if (_bannerItems.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerItems.length, (idx) {
              final isActive = idx == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.grey300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
      ],
    );
  }
}
