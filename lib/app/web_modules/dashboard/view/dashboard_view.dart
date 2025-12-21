import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/routes/app_routes.dart';
import 'package:blooket/app/web_modules/dashboard/widgets/dashboard_app_bar.dart';
import 'package:blooket/app/web_modules/auth/controller/auth_controller.dart';
import 'package:blooket/app/web_modules/dashboard/widgets/dashboard_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/utils/dialogs.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Màu nền xám xanh hiện đại
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
            // --- PHẦN 1: BANNER CHÀO MỪNG ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dùng Obx để render tên động
                  Obx(() {
                    final user = authController.currentUser.value;
                    final name = user?.fullName ?? 'Admin';
                    return Text(
                      'Chào mừng trở lại, $name! 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  const Text(
                    'Hôm nay bạn muốn quản lý lớp học nào?',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- PHẦN 2: THÔNG SỐ NHANH (QUICK STATS) ---
            // const Text(
            //   'Tổng quan nhanh',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 16),
            // const Wrap(
            //   spacing: 20,
            //   runSpacing: 20,
            //   children: [
            //     StatCard(
            //       label: 'Tổng Học viên',
            //       value: '124',
            //       icon: Icons.groups,
            //       color: Colors.blue,
            //     ),
            //     StatCard(
            //       label: 'Bài tập đang chờ',
            //       value: '12',
            //       icon: Icons.assignment_late,
            //       color: Colors.orange,
            //     ),
            //     StatCard(
            //       label: 'Lớp đang hoạt động',
            //       value: '05',
            //       icon: Icons.class_,
            //       color: Colors.green,
            //     ),
            //     StatCard(
            //       label: 'Đánh giá trung bình',
            //       value: '4.8',
            //       icon: Icons.star,
            //       color: Colors.amber,
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 40),

            // --- PHẦN 3: MENU CHÍNH (3 CÁI MODULE CŨ) ---
            const Text(
              'Chức năng chính',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

            // Khoảng trắng dưới cùng để không bị sát đáy
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
