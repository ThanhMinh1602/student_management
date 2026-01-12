import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AnswerRearrange extends StatefulWidget {
  // Callback trả về danh sách từ theo thứ tự hiện tại
  final Function(List<String> orderedWords)? onChanged;
  final List<String>? initialWords;

  const AnswerRearrange({super.key, this.onChanged, this.initialWords});

  @override
  State<AnswerRearrange> createState() => _AnswerRearrangeState();
}

class _AnswerRearrangeState extends State<AnswerRearrange> {
  List<String> words = [];
  final TextEditingController _sentenceController = TextEditingController();
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialWords != null && widget.initialWords!.isNotEmpty) {
      words = List.from(widget.initialWords!);
      // Tự điền vào input để user dễ sửa (nối lại thành chuỗi)
      _sentenceController.text = words.join(" ");
    }
  }

  @override
  void dispose() {
    _sentenceController.dispose();
    super.dispose();
  }

  // --- LOGIC ---

  void _notifyChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(words);
    }
  }

  void _generateChips() {
    final text = _sentenceController.text.trim();
    if (text.isEmpty) return;

    List<String> tempWords = [];
    // Regex: Bắt cụm trong [] HOẶC bắt từ đơn không chứa khoảng trắng
    final RegExp regExp = RegExp(r'\[([^\]]*)\]|(\S+)');
    final matches = regExp.allMatches(text);

    for (final match in matches) {
      if (match.group(1) != null) {
        String content = match.group(1)!.trim();
        if (content.isNotEmpty) tempWords.add(content);
      } else {
        tempWords.add(match.group(0)!);
      }
    }

    setState(() {
      words = tempWords;
    });
    _notifyChange();
  }

  void _shuffleChips() {
    setState(() {
      words.shuffle();
    });
    _notifyChange();
  }

  void _onSwap(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    setState(() {
      final temp = words[oldIndex];
      words[oldIndex] = words[newIndex];
      words[newIndex] = temp;
    });
    _notifyChange();
  }

  // --- UI BUILDER ---

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Khu vực hiển thị Chip (Result Area)
        _buildChipDisplayArea(),

        const SizedBox(height: 20),

        // 2. Khu vực nhập liệu (Input Area)
        _buildInputArea(),
      ],
    );
  }

  Widget _buildChipDisplayArea() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: words.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.text_fields,
                    size: 40,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nhập câu bên dưới (dùng [ ] để gom cụm)\nvà bấm 'Tách từ'",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          // SelectionContainer.disabled quan trọng cho Web để tránh bôi đen text khi kéo
          : SelectionContainer.disabled(
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.start,
                children: List.generate(words.length, (index) {
                  return _buildDraggableChip(index);
                }),
              ),
            ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Nhập câu hoàn chỉnh:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _sentenceController,
            maxLines: 3,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: "Ví dụ: Flutter [rất tuyệt] vời...",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColor.primary),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.content_cut, size: 18),
                  label: const Text("Tách từ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                  ),
                  onPressed: _generateChips,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shuffle, size: 18),
                  label: const Text("Xáo trộn"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColor.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: words.isNotEmpty ? _shuffleChips : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableChip(int index) {
    final word = words[index];

    return DragTarget<int>(
      onWillAccept: (data) => data != null && data != index,
      onAccept: (sourceIndex) => _onSwap(sourceIndex, index),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return MouseRegion(
          // Đổi con trỏ chuột: nắm tay khi kéo, bàn tay mở khi hover
          cursor: _isDragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          child: Draggable<int>(
            data: index,
            onDragStarted: () => setState(() => _isDragging = true),
            onDragEnd: (_) => setState(() => _isDragging = false),

            // 1. Feedback: Widget đi theo con trỏ chuột
            feedback: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 0.9,
                child: Transform.scale(
                  scale: 1.05, // Phóng to nhẹ tạo cảm giác đang nhấc lên
                  child: _buildChipUI(
                    word,
                    color: AppColor.pink,
                    isFeedback: true,
                  ),
                ),
              ),
            ),

            // 2. ChildWhenDragging: Widget ở vị trí cũ khi đang kéo đi (làm mờ)
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildChipUI(word, color: Colors.grey.shade500),
            ),

            // 3. Child: Widget hiển thị bình thường
            child: isHovering
                ? _buildSwapTargetUI(word) // Hiệu ứng khi sắp thả vào đây
                : _buildChipUI(word, color: AppColor.primary),
          ),
        );
      },
    );
  }

  // UI Chip cơ bản
  Widget _buildChipUI(
    String label, {
    required Color color,
    bool isFeedback = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          8,
        ), // Bo góc vừa phải trông hiện đại hơn
        boxShadow: isFeedback
            ? [
                BoxShadow(
                  color: AppColor.pink.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  // UI khi có item khác kéo đè lên (Drop Target)
  Widget _buildSwapTargetUI(String label) {
    return DottedBorderContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.pink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColor.pink.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// Widget phụ để vẽ viền nét đứt (Dotted Border) cho Target Swap
class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DottedBorderPainter(), child: child);
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.pink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8),
        ),
      );

    // Vẽ nét đứt thủ công đơn giản
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double distance = 0.0;

    // Lưu ý: Để vẽ nét đứt bo góc hoàn hảo cần path metric phức tạp
    // Ở đây vẽ viền liền mờ làm nền cho đơn giản và hiệu năng cao
    paint.color = AppColor.pink.withOpacity(0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
