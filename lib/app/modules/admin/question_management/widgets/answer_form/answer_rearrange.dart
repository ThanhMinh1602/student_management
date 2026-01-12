import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AnswerRearrange extends StatefulWidget {
  const AnswerRearrange({super.key});

  @override
  State<AnswerRearrange> createState() => _AnswerRearrangeState();
}

class _AnswerRearrangeState extends State<AnswerRearrange> {
  // Danh sách các từ (Chip) đang hiển thị
  List<String> words = [];

  // Controller cho ô nhập câu dài
  final TextEditingController _sentenceController = TextEditingController();

  // Biến check xem đang kéo hay không
  bool _isDragging = false;

  @override
  void dispose() {
    _sentenceController.dispose();
    super.dispose();
  }

  // --- LOGIC XỬ LÝ CHÍNH (ĐÃ SỬA) ---

  // 1. Tách câu thành các từ (Hỗ trợ ngoặc [])
  void _generateChips() {
    final text = _sentenceController.text.trim();
    if (text.isEmpty) return;

    List<String> tempWords = [];

    // Regex: Bắt cụm trong [] HOẶC bắt từ đơn
    final RegExp regExp = RegExp(r'\[([^\]]*)\]|(\S+)');

    final matches = regExp.allMatches(text);

    for (final match in matches) {
      if (match.group(1) != null) {
        // Lấy nội dung trong ngoặc []
        String content = match.group(1)!.trim();
        if (content.isNotEmpty) {
          tempWords.add(content);
        }
      } else {
        // Lấy từ đơn
        tempWords.add(match.group(0)!);
      }
    }

    setState(() {
      words = tempWords;
    });
  }

  // 2. Xáo trộn ngẫu nhiên (Shuffle)
  void _shuffleChips() {
    setState(() {
      words.shuffle();
    });
  }

  // 3. Đổi chỗ 2 chip (Swap)
  void _onSwap(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    setState(() {
      final temp = words[oldIndex];
      words[oldIndex] = words[newIndex];
      words[newIndex] = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- PHẦN 1: KHU VỰC HIỂN THỊ CHIP (Ở TRÊN) ---
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: words.isEmpty
              ? Center(
                  child: Text(
                    "Nhập câu (dùng [ ] để gom cụm) và bấm 'Tách từ'",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: List.generate(words.length, (index) {
                    return _buildDraggableChip(index);
                  }),
                ),
        ),

        const SizedBox(height: 20),

        // --- PHẦN 2: KHU VỰC NHẬP LIỆU (Ở DƯỚI) ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Nhập câu hoàn chỉnh:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _sentenceController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Ví dụ: Flutter [rất tuyệt] vời...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.content_cut, color: Colors.white),
                      label: const Text("Tách từ (Tạo Chip)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _generateChips,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shuffle, color: AppColor.primary),
                      label: const Text("Xáo trộn"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColor.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: words.isNotEmpty ? _shuffleChips : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET CHIP KÉO THẢ ---
  Widget _buildDraggableChip(int index) {
    final word = words[index];

    return DragTarget<int>(
      onWillAccept: (data) => data != null && data != index,
      onAccept: (sourceIndex) => _onSwap(sourceIndex, index),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Draggable<int>(
            data: index,
            onDragStarted: () => setState(() => _isDragging = true),
            onDragEnd: (_) => setState(() => _isDragging = false),

            feedback: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 0.8,
                child: Transform.scale(
                  scale: 1.1,
                  child: _buildChipUI(
                    word,
                    color: AppColor.pink,
                    isFeedback: true,
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildChipUI(word, color: Colors.grey),
            ),
            child: isHovering
                ? _buildSwapTargetUI(word)
                : _buildChipUI(word, color: AppColor.primary),
          ),
        );
      },
    );
  }

  Widget _buildChipUI(
    String label, {
    required Color color,
    bool isFeedback = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isFeedback
            ? [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSwapTargetUI(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.pink, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.swap_horiz, size: 20, color: AppColor.pink),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColor.pink,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
