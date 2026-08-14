import 'package:akar/core/widgets/custom_app_bar.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_list_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/my_complaint_history_page.dart';
import 'package:akar/features/masyarakat/home/presentation/pages/home_screen.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_state.dart';
import 'package:akar/features/masyarakat/main/presentation/widgets/custom_bottom_navbar.dart';
import 'package:akar/features/masyarakat/notification/data/dummy_notifications.dart';
import 'package:akar/features/masyarakat/notification/presentation/pages/notification_page.dart';
import 'package:akar/features/masyarakat/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MasyarakatMainScreen extends StatefulWidget {
  const MasyarakatMainScreen({super.key});

  @override
  State<MasyarakatMainScreen> createState() => _MasyarakatMainScreenState();
}

class _MasyarakatMainScreenState extends State<MasyarakatMainScreen> {
  int get _unreadCount => dummyNotifications.where((n) => !n.isRead).length;

  void _handleNotificationTap() async {
    setState(() {
      for (var item in dummyNotifications) {
        item.isRead = true;
      }
    });
    await NotificationPage.show(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            unreadCount: _unreadCount,
            onNotificationPressed: _handleNotificationTap,
          ),
          body: IndexedStack(
            index: state.selectedIndex,
            children: const [
              HomeScreen(),
              ComplaintListPage(),
              SizedBox.shrink(),
              MyComplaintHistoryPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: state.selectedIndex,
            onTapTab: (index) {
              if (index == 0 || index == 1 || index == 3 || index == 4) {
                context.read<MainCubit>().changeTab(index);
              }
            },
            onTapFab: () async {
              final result = await CreateComplaintPage.show(context);
              if (result == true && context.mounted) {
                context.read<MainCubit>().changeTab(0);
                setState(() {});
              }
            },
          ),
        );
      },
    );
  }
}
