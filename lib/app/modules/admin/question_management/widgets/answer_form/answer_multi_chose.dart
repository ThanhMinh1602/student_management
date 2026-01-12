import 'package:blooket/app/core/constants/app_color.dart'; // Check lại import đúng project của bạn
import 'package:flutter/material.dart';

class AnswerMultiChose extends StatefulWidget {
  final Function(int correctIndex, List<String> answers)? onChanged;

  const AnswerMultiChose({super.key, this.onChanged});

  @override
  State<AnswerMultiChose> createState() => _AnswerMultiChoseState();
}

class _AnswerMultiChoseState extends State<AnswerMultiChose> {
  int _selectedAnswerIndex = 0;
  late List<TextEditingController> _controllers;

  // Biến lưu trạng thái hover cho 4 ô đáp án
  final List<bool> _isHovering = List.generate(4, (index) => false);

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) => TextEditingController());

    // Lắng nghe thay đổi text
    for (var controller in _controllers) {
      controller.addListener(_notifyChange);
    }
  }

  void _notifyChange() {
    if (widget.onChanged != null) {
      final answers = _controllers.map((e) => e.text).toList();
      widget.onChanged!(_selectedAnswerIndex, answers);
    }
  }

  void _onSelectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
    _notifyChange();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trên Web, GridView.count hoặc extent thường ổn định hơn
    // Tuy nhiên, để kiểm soát chiều cao (Height) của item mà không phụ thuộc Width
    // Ta dùng: childAspectRatio = (Width / Height).
    // Mẹo: Dùng LayoutBuilder để tính ratio động.

    return LayoutBuilder(
      builder: (context, constraints) {
        // Giả sử ta muốn 2 cột.
        final crossAxisCount = 2;
        final spacing = 20.0;
        final totalSpacing = spacing * (crossAxisCount - 1);

        // Tính chiều rộng thực tế của 1 item
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        // Chiều cao mong muốn cho Web (đủ để hiển thị đẹp): 80px
        const itemHeight = 80.0;

        final ratio = itemWidth / itemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // Bỏ padding cứng ở đây, để cha quản lý sẽ linh hoạt hơn
          padding: EdgeInsets.zero,
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: ratio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            return _buildWebAnswerItem(index);
          },
        );
      },
    );
  }

  Widget _buildWebAnswerItem(int index) {
    final isSelected = _selectedAnswerIndex == index;
    final isHovering = _isHovering[index];

    // Logic màu sắc cho Web:
    // - Selected: Viền hồng đậm, nền hồng nhạt.
    // - Hover: Viền xám đậm hơn chút, nền xám siêu nhạt.
    // - Normal: Viền xám, nền trắng.

    Color borderColor;
    double borderWidth;
    Color backgroundColor;

    if (isSelected) {
      borderColor = AppColor.pink;
      borderWidth = 2.5;
      backgroundColor = AppColor.pink.withOpacity(0.08);
    } else if (isHovering) {
      borderColor = Colors.grey.shade500;
      borderWidth = 1.5;
      backgroundColor = Colors.grey.shade50;
    } else {
      borderColor = Colors.grey.shade300;
      borderWidth = 1.0;
      backgroundColor = Colors.white;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click, // Hiển thị con trỏ tay khi hover khung
      onEnter: (_) => setState(() => _isHovering[index] = true),
      onExit: (_) => setState(() => _isHovering[index] = false),
      child: GestureDetector(
        onTap: () => _onSelectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Hiệu ứng mượt mà
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: isSelected || isHovering
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // --- RADIO BUTTON ---
              // Trên web nên làm to ra một chút
              Transform.scale(
                scale: 1.2,
                child: Radio<int>(
                  value: index,
                  groupValue: _selectedAnswerIndex,
                  activeColor: AppColor.pink,
                  // Tắt hiệu ứng ripple mặc định để tránh rối mắt trên web
                  splashRadius: 20,
                  onChanged: (val) => _onSelectAnswer(val!),
                ),
              ),
              const SizedBox(width: 12),

              // --- INPUT FIELD ---
              Expanded(
                child: TextField(
                  controller: _controllers[index],
                  // Quan trọng: Khi hover vào text field thì trỏ thành I-Beam (soạn thảo)
                  mouseCursor: SystemMouseCursors.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Answer ${index + 1}',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              // --- OPTIONAL: ICON TRẠNG THÁI ---
              // Hiển thị icon check nếu đang chọn (visual feedback tốt cho web)
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColor.pink, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
