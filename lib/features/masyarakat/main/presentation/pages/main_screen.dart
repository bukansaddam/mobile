import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/custom_app_bar.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_list_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/my_complaint_history_page.dart';
import 'package:akar/features/masyarakat/home/presentation/pages/home_screen.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_state.dart';
import 'package:akar/features/masyarakat/main/presentation/widgets/custom_bottom_navbar.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_navigation_helper.dart';
import 'package:akar/features/profile/presentation/pages/masyarakat_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MasyarakatMainScreen extends StatefulWidget {
  const MasyarakatMainScreen({super.key});

  @override
  State<MasyarakatMainScreen> createState() => _MasyarakatMainScreenState();
}

class _MasyarakatMainScreenState extends State<MasyarakatMainScreen> {
  void _handleNotificationTap() {
    NotificationNavigationHelper.openNotificationCenter(context);
  }

  Future<void> _openCreateComplaint(BuildContext context) async {
    final result = await CreateComplaintPage.show(context);
    if (result == true && context.mounted) {
      context.read<MainCubit>().changeTab(0);
      context.read<MyComplaintListBloc>().add(
        const FetchMyComplaintsEvent(isRefresh: true),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocProvider(
      create: (_) =>
          sl<MyComplaintListBloc>()..add(const FetchMyComplaintsEvent()),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(onNotificationPressed: _handleNotificationTap),
            body: IndexedStack(
              index: state.selectedIndex,
              children: const [
                HomeScreen(),
                ComplaintListPage(),
                SizedBox.shrink(),
                MyComplaintHistoryPage(),
                MasyarakatProfileScreen(),
              ],
            ),
            floatingActionButton: GestureDetector(
              onTap: () => _openCreateComplaint(context),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  gradient: colors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withAlpha(100),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: colors.isDark ? colors.textPrimary : colors.onPrimary,
                  size: 32,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: state.selectedIndex,
              onTapTab: (index) {
                if (index == 0 || index == 1 || index == 3 || index == 4) {
                  context.read<MainCubit>().changeTab(index);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
