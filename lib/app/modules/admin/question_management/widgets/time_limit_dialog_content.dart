import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// --- HÀM GỌI DIALOG (ĐÃ SỬA) ---
// 1. Đổi return type thành Future<int>
// 2. Thêm tham số defaultValue (mặc định là 0 nếu người dùng hủy)
Future<int> showTimeLimitDialog({int defaultValue = 0}) async {
  final result = await Get.dialog(
    const _TimeLimitDialogContent(),
    barrierDismissible: true,
  );

  // Nếu người dùng bấm Lưu (có kết quả trả về)
  if (result != null && result is int) {
    return result;
  }

  // Nếu người dùng bấm Hủy hoặc bấm ra ngoài -> Trả về giá trị mặc định
  return defaultValue;
}

// --- WIDGET NỘI DUNG (GIỮ NGUYÊN LOGIC, CHỈNH LẠI UI XÍU) ---
class _TimeLimitDialogContent extends StatefulWidget {
  const _TimeLimitDialogContent();

  @override
  State<_TimeLimitDialogContent> createState() =>
      _TimeLimitDialogContentState();
}

class _TimeLimitDialogContentState extends State<_TimeLimitDialogContent> {
  final TextEditingController _controller = TextEditingController();
  final List<int> presets = [20, 30, 60];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Cài đặt thời gian (giây)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Chọn nhanh
              Wrap(
                spacing: 10,
                children: presets.map((seconds) {
                  return ActionChip(
                    label: Text("${seconds}s"),
                    backgroundColor: AppColor.green.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppColor.green),
                    onPressed: () {
                      _controller.text = seconds.toString();
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 15),
              const Text(
                "Hoặc nhập số tùy ý:",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),

              // Ô nhập liệu
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Nhập số giây...",
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixText: "s",
                ),
              ),

              const SizedBox(height: 25),

              // Hàng nút bấm
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      // Khi Hủy: trả về null (Get.dialog sẽ nhận null)
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          final int? value = int.tryParse(text);
                          if (value != null && value > 0) {
                            // Khi Lưu: Trả về số int
                            Get.back(result: value);
                          }
                        }
                      },
                      child: const Text("Lưu"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
