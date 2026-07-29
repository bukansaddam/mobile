import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraCaptureScreen {
  CameraCaptureScreen._();

  /// Membuka kamera perangkat HP secara langsung tanpa antarmuka simulasi.
  static Future<String?> open(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      return photo?.path;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka kamera perangkat: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    }
  }
}
