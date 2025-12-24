import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartButton extends StatefulWidget {
  final VoidCallback onTap;

  const StartButton({super.key, required this.onTap});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Đổi con trỏ chuột thành hình bàn tay
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0, // Phóng to 5% khi hover
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFFFFF0F5) : Colors.white,
              // Hover thì trắng tinh, bình thường hơi hồng nhạt
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, color: AppColor.pink, size: 24),
                const SizedBox(width: 8),
                Text(
                  'START',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColor.pink,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
