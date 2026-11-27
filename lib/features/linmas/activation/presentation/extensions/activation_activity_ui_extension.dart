import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:flutter/material.dart';

extension ActivationCategoryUiExtension on ActivationCategory {
  Color resolveColor(AppColorScheme colors) {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return colors.emerald;
      case ActivationCategory.doorToDoor:
        return colors.indigo;
      case ActivationCategory.lingkungan:
        return colors.success;
      case ActivationCategory.keamananDanSosial:
        return colors.info;
      case ActivationCategory.bencanaAlam:
        return colors.error;
    }
  }

  Color resolveStripColor(AppColorScheme colors) => resolveColor(colors);

  Color get color {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return const Color(0xFF00897B);
      case ActivationCategory.doorToDoor:
        return const Color(0xFF8E24AA);
      case ActivationCategory.lingkungan:
        return const Color(0xFF20D489);
      case ActivationCategory.keamananDanSosial:
        return const Color(0xFF1E6FFF);
      case ActivationCategory.bencanaAlam:
        return const Color(0xFFFF5252);
    }
  }

  Color get stripColor => color;

  IconData get icon {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return Icons.flag_rounded;
      case ActivationCategory.doorToDoor:
        return Icons.meeting_room_rounded;
      case ActivationCategory.lingkungan:
        return Icons.eco_rounded;
      case ActivationCategory.keamananDanSosial:
        return Icons.security_rounded;
      case ActivationCategory.bencanaAlam:
        return Icons.warning_amber_rounded;
    }
  }
}

extension ActivationStatusUiExtension on ActivationStatus {
  Color resolveColor(AppColorScheme colors) {
    switch (this) {
      case ActivationStatus.terjadwal:
        return colors.warningDark;
      case ActivationStatus.sedangBerjalan:
        return colors.info;
      case ActivationStatus.selesai:
        return colors.primaryDark;
      case ActivationStatus.dibatalkan:
        return colors.errorDark;
    }
  }

  Color resolveBackgroundColor(AppColorScheme colors) {
    switch (this) {
      case ActivationStatus.terjadwal:
        return colors.warningLight;
      case ActivationStatus.sedangBerjalan:
        return colors.infoLight;
      case ActivationStatus.selesai:
        return colors.primaryLight;
      case ActivationStatus.dibatalkan:
        return colors.errorLight;
    }
  }

  Color get color {
    switch (this) {
      case ActivationStatus.terjadwal:
        return const Color(0xFFF57F17);
      case ActivationStatus.sedangBerjalan:
        return const Color(0xFF1877F2);
      case ActivationStatus.selesai:
        return const Color(0xFF2E7D32);
      case ActivationStatus.dibatalkan:
        return const Color(0xFFC62828);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ActivationStatus.terjadwal:
        return const Color(0xFFFFF8E1);
      case ActivationStatus.sedangBerjalan:
        return const Color(0xFFE8F1FF);
      case ActivationStatus.selesai:
        return const Color(0xFFE8F5E9);
      case ActivationStatus.dibatalkan:
        return const Color(0xFFFFEBEE);
    }
  }
}
