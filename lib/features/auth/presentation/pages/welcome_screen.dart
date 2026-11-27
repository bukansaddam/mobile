import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/entrance_transition.dart';
import 'package:akar/features/auth/presentation/widgets/feature_avatar_triad.dart';
import 'package:akar/features/auth/presentation/widgets/indonesia_dotted_map.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  int _selectedFeature = 1; // Default to center feature

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  List<FeatureHighlightItem> _buildFeatures(AppColorScheme colors) => [
    FeatureHighlightItem(
      title: 'Tanggap Darurat',
      description: 'Laporkan kejadian darurat secara instan untuk respon cepat dan terkoordinasi dari petugas Aslinmas terdekat.',
      icon: Icons.crisis_alert_rounded,
      iconColor: colors.error,
      backgroundColor: colors.errorLight,
    ),
    FeatureHighlightItem(
      title: 'Kolaborasi Warga & Aslinmas',
      description: 'Sinergi aktif antara masyarakat dan petugas Aslinmas demi terciptanya lingkungan yang aman, tertib, dan harmonis.',
      icon: Icons.shield_rounded,
      iconColor: colors.primary,
      backgroundColor: colors.primaryLight,
    ),
    FeatureHighlightItem(
      title: 'Pemantauan Wilayah',
      description: 'Pantau situasi pos kamling dan rute patroli keamanan lingkungan sekitar Anda secara real-time.',
      icon: Icons.radar_rounded,
      iconColor: colors.info,
      backgroundColor: colors.infoLight,
    ),
  ];

  void _onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null) return;

    if (velocity < -200) {
      if (_selectedFeature < 2) {
        setState(() => _selectedFeature++);
      }
    } else if (velocity > 200) {
      if (_selectedFeature > 0) {
        setState(() => _selectedFeature--);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final features = _buildFeatures(colors);
    final activeItem = features[_selectedFeature];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primaryLight,
              colors.surfaceVariant,
              colors.isDark ? colors.background : colors.surface,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 12),
                                EntranceTransition(
                                  animation: _entranceController,
                                  start: 0,
                                  end: 0.45,
                                  child: IndonesiaDottedMap(
                                    mapColor: colors.textHint,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(0, 25),
                                  child: EntranceTransition(
                                    animation: _entranceController,
                                    start: 0.1,
                                    end: 0.55,
                                    child: FeatureAvatarTriad(
                                      selectedIndex: _selectedFeature,
                                      items: features,
                                      onSelected: (index) {
                                        setState(
                                          () => _selectedFeature = index,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onHorizontalDragEnd: _onSwipe,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 24.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  EntranceTransition(
                                    animation: _entranceController,
                                    start: 0.3,
                                    end: 0.72,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 280,
                                      ),
                                      switchInCurve: Curves.easeOutCubic,
                                      switchOutCurve: Curves.easeInCubic,
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0.04, 0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: KeyedSubtree(
                                        key: ValueKey(_selectedFeature),
                                        child: Column(
                                          children: [
                                            Text(
                                              activeItem.title,
                                              style: AppTextStyles.headlineLarge
                                                  .copyWith(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w800,
                                                    color: colors.textPrimary,
                                                    letterSpacing: -0.5,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                  ),
                                              child: Text(
                                                activeItem.description,
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      color:
                                                          colors.textSecondary,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  EntranceTransition(
                                    animation: _entranceController,
                                    start: 0.4,
                                    end: 0.82,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (
                                          int i = 0;
                                          i < features.length;
                                          i++
                                        )
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              setState(
                                                () => _selectedFeature = i,
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4.0,
                                                  ),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                width: _selectedFeature == i
                                                    ? 20.0
                                                    : 6.0,
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: _selectedFeature == i
                                                      ? colors.primary
                                                      : colors.borderStrong,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        3.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            EntranceTransition(
                              animation: _entranceController,
                              start: 0.5,
                              end: 0.92,
                              child: ElevatedButton.icon(
                                onPressed: () => context.pushNamed(
                                  'login',
                                  queryParameters: {'role': 'masyarakat'},
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                icon: const Icon(Icons.people_alt_rounded),
                                label: const Text(
                                  'Masuk sebagai Masyarakat',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            EntranceTransition(
                              animation: _entranceController,
                              start: 0.58,
                              end: 1,
                              child: OutlinedButton.icon(
                                onPressed: () => context.pushNamed(
                                  'login',
                                  queryParameters: {'role': 'linmas'},
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colors.primary,
                                  side: BorderSide(
                                    color: colors.primary,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.shield_rounded),
                                label: const Text(
                                  'Masuk sebagai Aslinmas',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
