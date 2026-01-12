import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AnswerTrueFalse extends StatefulWidget {
  // Callback trả về giá trị đúng (true) hoặc sai (false)
  final Function(bool isTrue)? onChanged;

  // Giá trị ban đầu (nếu đang edit)
  final bool? initialValue;

  const AnswerTrueFalse({super.key, this.onChanged, this.initialValue});

  @override
  State<AnswerTrueFalse> createState() => _AnswerTrueFalseState();
}

class _AnswerTrueFalseState extends State<AnswerTrueFalse> {
  // null: chưa chọn, true: Chọn Đúng, false: Chọn Sai
  bool? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _selectedAnswer = widget.initialValue;
  }

  void _onSelect(bool value) {
    setState(() {
      _selectedAnswer = value;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding này nên để widget cha quản lý, nhưng thêm vào đây để demo cho đẹp
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          // --- CARD TRUE ---
          Expanded(
            child: _buildOptionCard(
              label: "TRUE",
              value: true,
              color: AppColor.trueBlue,
              icon: Icons.check,
            ),
          ),

          const SizedBox(width: 20), // Khoảng cách giữa 2 nút
          // --- CARD FALSE ---
          Expanded(
            child: _buildOptionCard(
              label: "FALSE",
              value: false,
              color: AppColor.falseRed,
              icon: Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String label,
    required bool value,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = _selectedAnswer == value;
    final isNotSelectedButHasValue =
        _selectedAnswer != null && _selectedAnswer != value;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onSelect(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 200, // Chiều cao cố định cho đẹp
          decoration: BoxDecoration(
            color: color.withOpacity(
              isSelected ? 1.0 : (isNotSelectedButHasValue ? 0.3 : 0.8),
            ),
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: Colors.black, width: 4) // Viền đậm khi chọn
                : Border.all(color: Colors.transparent, width: 4),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Icon nền mờ (Trang trí)
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 120,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),

              // Nội dung chính
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkbox icon xác nhận đã chọn (Góc trên)
              if (isSelected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: color, size: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
