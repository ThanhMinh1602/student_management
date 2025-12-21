import 'package:blooket/app/core/components/appbar/custom_app_bar.dart'; // Import AppBar của bạn
import 'package:blooket/app/web_modules/class_management/controller/class_management_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassManagementDetailView
    extends GetView<ClassManagementDetailController> {
  const ClassManagementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor, // Màu nền tím nhạt 0xFFDCD6F7
      appBar: const CustomAppBar(title: 'Quản Lý Học Viên'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DANH SÁCH LỚP HSK3',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    shadows: [
                      const Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                _buildAddButton(context),
              ],
            ),

            const SizedBox(height: 30),

            // 2. Bảng dữ liệu (Container trắng bo góc)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Obx(() => _buildDataTable(context)),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CON: Bảng dữ liệu ---
  Widget _buildDataTable(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.transparent),
      dataRowColor: MaterialStateProperty.all(Colors.transparent),
      columnSpacing: 30,
      horizontalMargin: 10,
      columns: [
        _buildHeader('Họ và tên'),
        _buildHeader('Username'),
        _buildHeader('Tổng thời gian'),
        _buildHeader('Điểm TB'),
        _buildHeader('Trạng thái'),
        _buildHeader('Hành động', alignEnd: true),
      ],
      rows: controller.students.map((student) {
        return DataRow(
          cells: [
            // 1. Họ tên (Có avatar nhỏ)
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: controller.primaryColor.withOpacity(0.2),
                    child: Text(
                      student.fullName[0],
                      style: TextStyle(
                        color: controller.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    student.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // 2. Username
            DataCell(
              Text(
                student.username,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            // 3. Thời gian
            DataCell(Text(' phút')),
            // 4. Điểm TB (Badge màu)
            DataCell(_buildScoreBadge(student.avgScore)),
            // 5. Trạng thái
            DataCell(_buildStatusBadge(student.isActive)),
            // 6. Hành động
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildIconButton(
                    Icons.lock_reset,
                    Colors.orange,
                    () => controller.resetPassword(student.id),
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(
                    student.isActive ? Icons.block : Icons.check_circle,
                    student.isActive ? Colors.red : Colors.green,
                    () => controller.toggleStatus(student.id),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // --- CÁC WIDGET NHỎ THEO VIBE ---

  DataColumn _buildHeader(String text, {bool alignEnd = false}) {
    return DataColumn(
      numeric: alignEnd,
      label: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: controller.primaryColor, // Màu xanh tím cho header
          fontWeight: FontWeight.w900,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddDialog(context),
      icon: const Icon(Icons.person_add, color: Colors.white),
      label: const Text(
        'THÊM HỌC VIÊN',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.accentColor, // Màu hồng 0xFFEDBBC6
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: controller.accentColor.withOpacity(0.4),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  Widget _buildScoreBadge(double score) {
    Color color = score >= 8
        ? Colors.green
        : (score >= 5 ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        score.toString(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Đang học' : 'Đã nghỉ',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- DIALOG ADD STUDENT (Style hồng) ---
  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final userCtrl = TextEditingController();

    Get.defaultDialog(
      title: "THÊM HỌC VIÊN",
      titleStyle: TextStyle(
        color: controller.primaryColor,
        fontWeight: FontWeight.w900,
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          _buildTextField(nameCtrl, 'Họ và tên', Icons.person),
          const SizedBox(height: 16),
          _buildTextField(userCtrl, 'Username', Icons.alternate_email),
          const SizedBox(height: 10),
          const Text(
            'Mật khẩu mặc định: 123456',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.accentColor, // Màu hồng
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => controller.addStudent(nameCtrl.text, userCtrl.text),
          child: const Text(
            'XÁC NHẬN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
      ),
      radius: 20,
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: controller.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: controller.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
