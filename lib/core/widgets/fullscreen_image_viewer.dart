import 'dart:io';
import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String imagePathOrUrl;
  final String? title;

  const FullscreenImageViewer({
    super.key,
    required this.imagePathOrUrl,
    this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required String imagePathOrUrl,
    String? title,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullscreenImageViewer(imagePathOrUrl: imagePathOrUrl, title: title),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildImage() {
    if (imagePathOrUrl.startsWith('http://') ||
        imagePathOrUrl.startsWith('https://')) {
      return Image.network(
        imagePathOrUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_rounded, color: Colors.white54, size: 64),
              SizedBox(height: 12),
              Text(
                'Gagal memuat gambar',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    } else {
      final file = File(imagePathOrUrl);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(
              Icons.broken_image_rounded,
              color: Colors.white54,
              size: 64,
            ),
          ),
        );
      } else {
        return Image.network(
          imagePathOrUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(
              Icons.broken_image_rounded,
              color: Colors.white54,
              size: 64,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Pinch-to-zoom interactive viewer
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(child: _buildImage()),
              ),
            ),

            // Top Header Bar
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      tooltip: 'Tutup',
                    ),
                  ),
                  if (title != null && title!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Bottom hint label
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Cubit / Zoom untuk memperbesar foto',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
