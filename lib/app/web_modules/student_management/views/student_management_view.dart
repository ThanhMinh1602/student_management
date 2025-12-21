import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/web_modules/student_management/controllers/student_management_controller.dart';
import 'package:blooket/app/data/model/student_model.dart';

class StudentManagementView extends GetView<StudentManagementController> {
  const StudentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD6F7),
      appBar: const CustomAppBar(title: 'Hệ Thống Quản Trị'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            // 1. Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUẢN LÝ TÀI KHOẢN',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        shadows: [const Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black12)],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Danh sách toàn bộ học viên trong hệ thống',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
                _buildAddButton(),
              ],
            ),

            const SizedBox(height: 30),

            // 2. Data Table
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4), blurRadius: 10),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (controller.studentList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: Text("Hệ thống chưa có tài khoản nào.", style: TextStyle(color: Colors.grey))),
                  );
                }
                return DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.transparent),
                  columnSpacing: 20,
                  horizontalMargin: 10,
                  columns: const [
                    DataColumn(label: Text('HỌ TÊN', style: TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900))),
                    DataColumn(label: Text('USERNAME', style: TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900))),
                    DataColumn(label: Text('VAI TRÒ', style: TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900))), // 🔥 THÊM CỘT NÀY
                    DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900))),
                    DataColumn(label: Text('HÀNH ĐỘNG', style: TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900)), numeric: true),
                  ],
                  rows: controller.studentList.map((student) => _buildDataRow(student)).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: controller.showAddStudentDialog,
      icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
      label: const Text('CẤP TÀI KHOẢN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF88D8B0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }

  DataRow _buildDataRow(StudentModel student) {
    return DataRow(
      cells: [
        // 1. Họ tên
        DataCell(Row(
          children: [
            CircleAvatar(
              radius: 16,
              // Nếu là Admin thì avatar màu khác cho dễ nhìn
              backgroundColor: student.role == 'admin' 
                  ? Colors.orangeAccent.withOpacity(0.2) 
                  : const Color(0xFF909CC2).withOpacity(0.2),
              child: Text(
                student.fullName.isNotEmpty ? student.fullName[0].toUpperCase() : '?', 
                style: TextStyle(
                  color: student.role == 'admin' ? Colors.orange : const Color(0xFF909CC2), 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            const SizedBox(width: 12),
            Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        )),
        
        // 2. Username
        DataCell(Text(student.username, style: TextStyle(color: Colors.grey[600]))),

        // 3. Vai trò (Role) - 🔥 MỚI
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: student.role == 'admin' ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            student.role == 'admin' ? 'Quản trị viên' : 'Học viên',
            style: TextStyle(
              color: student.role == 'admin' ? Colors.blue : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        )),

        // 4. Trạng thái
        DataCell(_buildStatusBadge(student.isActive)),

        // 5. Hành động
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              tooltip: "Reset Password",
              icon: const Icon(Icons.lock_reset, color: Colors.orangeAccent),
              onPressed: () => controller.resetPassword(student.id),
            ),
            IconButton(
              tooltip: student.isActive ? "Khóa" : "Mở khóa",
              icon: Icon(student.isActive ? Icons.block : Icons.check_circle_outline, 
                color: student.isActive ? Colors.redAccent : Colors.green),
              onPressed: () => controller.toggleStatus(student),
            ),
             IconButton(
              tooltip: "Xóa tài khoản",
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () => controller.deleteStudent(student.id),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Locked',
        style: TextStyle(color: isActive ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}