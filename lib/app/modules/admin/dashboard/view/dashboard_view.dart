import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';
import 'package:blooket/app/routes/app_routes.dart';
import 'package:blooket/app/modules/admin/dashboard/widgets/dashboard_app_bar.dart';
import 'package:blooket/app/modules/auth/controller/auth_controller.dart';
import 'package:blooket/app/modules/admin/dashboard/widgets/dashboard_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/utils/dialogs.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final user = authController.currentUser.value;
          final name = user?.fullName ?? 'Admin';
          final avatar = null; // nếu có field avatar trong model thì truyền vào
          return DashboardAppBar(
            userName: name,
            avatarUrl: avatar,
            onAvatarTap: () {
              AppDialogs.showLogoutConfirm(onConfirm: () {
                authController.logout();
              });
            },
          );
        }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.95),
                    AppColors.action.withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final user = authController.currentUser.value;
                    final name = user?.fullName ?? 'Admin';
                    return Text(
                      'Chào mừng trở lại, $name! 👋',
                      style: AppTextStyles.bannerTitle,
                    );
                  }),
                  const SizedBox(height: 8),
                  Text(
                    'Hôm nay bạn muốn quản lý lớp học nào?',
                    style: AppTextStyles.bodyText.copyWith(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Main actions header
            Text(
              'Chức năng chính',
              style: AppTextStyles.bodyText.copyWith(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                DashboardItemCard(
                  title: 'Quản lý học viên',
                  subtitle: 'Cấp tài khoản',
                  icon: Icons.person_outline_rounded,
                  color: Colors.purpleAccent,
                  onTap: () {
                    Get.toNamed(
                      '${Get.currentRoute}${AppRoutes.STUDENT_MANAGEMENT}',
                    );
                  },
                ),
                DashboardItemCard(
                  title: 'Quản lý lớp',
                  subtitle: 'Cấp tài khoản, xếp lớp...',
                  icon: Icons.people_alt_rounded,
                  color: Colors.blueAccent,
                  onTap: () {
                    Get.toNamed(
                      '${Get.currentRoute}${AppRoutes.CLASS_MANAGEMENT}',
                    );
                  },
                ),
                DashboardItemCard(
                  title: 'Ngân hàng câu hỏi',
                  subtitle: 'Soạn đề thi và giao bài...',
                  icon: Icons.quiz_rounded,
                  color: Colors.orangeAccent,
                  onTap: () {
                    Get.toNamed(
                      '${Get.currentRoute}${AppRoutes.QUESTION_MANAGEMENT}',
                    );
                  },
                ),
                DashboardItemCard(
                  title: 'Thống kê & Báo cáo',
                  subtitle: 'Xem kết quả làm bài...',
                  icon: Icons.bar_chart_rounded,
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
            ),

            // Bottom padding
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
