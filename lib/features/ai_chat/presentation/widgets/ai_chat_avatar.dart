import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:material_ui/material_ui.dart';

/// Avatar lingkaran resmi Asisten Virtual Siska dari aset lokal.
class AiChatAvatar extends StatelessWidget {
  final double size;

  const AiChatAvatar({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ClipOval(
      child: Image.asset(
        AppConstants.siskaAvatarAsset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          color: colors.primary,
          alignment: Alignment.center,
          child: Icon(
            Icons.auto_awesome_rounded,
            size: size * 0.5,
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
