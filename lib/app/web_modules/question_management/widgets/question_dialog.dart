import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/data/model/question_model.dart';

class QuestionDialog extends StatefulWidget {
  final String setId;
  final QuestionModel? initialData; // Nếu có data -> Edit Mode
  final Function(QuestionModel) onSave;

  const QuestionDialog({
    super.key, 
    required this.setId, 
    required this.onSave, 
    this.initialData
  });

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late QuestionType selectedType;
  final contentCtrl = TextEditingController();
  
  // Trắc nghiệm
  final List<TextEditingController> optionsCtrl = List.generate(4, (_) => TextEditingController());
  int correctOptionIndex = 0;

  // Tự luận / Sắp xếp
  final answerCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Đổ dữ liệu cũ vào form nếu đang Edit
    if (widget.initialData != null) {
      final q = widget.initialData!;
      selectedType = q.type;
      contentCtrl.text = q.content;

      if (q.type == QuestionType.multipleChoice && q.options != null) {
        for (int i = 0; i < 4; i++) {
          if (i < q.options!.length) {
            optionsCtrl[i].text = q.options![i];
            if (q.options![i] == q.correctAnswer) correctOptionIndex = i;
          }
        }
      } else {
        answerCtrl.text = q.correctAnswer;
      }
    } else {
      selectedType = QuestionType.multipleChoice; // Mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? "CHỈNH SỬA CÂU HỎI" : "TẠO CÂU HỎI MỚI", 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF909CC2))
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // 1. Loại câu hỏi (Disable nếu đang sửa)
              DropdownButtonFormField<QuestionType>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: "Loại câu hỏi",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isEditing ? Colors.grey.shade200 : Colors.white,
                ),
                onChanged: isEditing ? null : (val) => setState(() => selectedType = val!),
                items: const [
                  DropdownMenuItem(value: QuestionType.multipleChoice, child: Text("Trắc nghiệm (4 đáp án)")),
                  DropdownMenuItem(value: QuestionType.rearrange, child: Text("Sắp xếp câu")),
                  DropdownMenuItem(value: QuestionType.translate, child: Text("Dịch câu")),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Nội dung
              TextField(
                controller: contentCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Nội dung câu hỏi / Đề bài",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 16),

              // 3. UI Động
              if (selectedType == QuestionType.multipleChoice) _buildMultipleChoiceForm(),
              if (selectedType == QuestionType.rearrange) _buildRearrangeForm(),
              if (selectedType == QuestionType.translate) _buildTranslateForm(),

              const SizedBox(height: 24),

              // Button Save
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.orangeAccent : const Color(0xFF88D8B0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _handleSave,
                child: Text(
                  isEditing ? "CẬP NHẬT" : "LƯU CÂU HỎI", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nhập 4 đáp án và chọn đáp án đúng:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...List.generate(4, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: correctOptionIndex,
                activeColor: Colors.green,
                onChanged: (val) => setState(() => correctOptionIndex = val!),
              ),
              Expanded(
                child: TextField(
                  controller: optionsCtrl[index],
                  decoration: InputDecoration(
                    hintText: "Đáp án ${String.fromCharCode(65 + index)}",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildRearrangeForm() {
    return TextField(
      controller: answerCtrl,
      decoration: InputDecoration(
        labelText: "Câu hoàn chỉnh (Đáp án đúng)",
        helperText: "VD: Wo ai ni (Hệ thống sẽ tự tách từ để xáo trộn)",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTranslateForm() {
    return TextField(
      controller: answerCtrl,
      decoration: InputDecoration(
        labelText: "Đáp án dịch đúng",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleSave() {
    if (contentCtrl.text.isEmpty) return;

    List<String>? options;
    String correctAnswer = "";
    List<String>? correctOrder;

    if (selectedType == QuestionType.multipleChoice) {
      options = optionsCtrl.map((e) => e.text.trim()).toList();
      if (options.any((e) => e.isEmpty)) return; 
      correctAnswer = options[correctOptionIndex];
    } else if (selectedType == QuestionType.rearrange) {
      correctAnswer = answerCtrl.text.trim();
      correctOrder = correctAnswer.split(" ");
    } else {
      correctAnswer = answerCtrl.text.trim();
    }

    final question = QuestionModel(
      id: widget.initialData?.id ?? '', // Nếu Edit thì lấy ID cũ
      setId: widget.setId,
      type: selectedType,
      content: contentCtrl.text.trim(),
      options: options,
      correctAnswer: correctAnswer,
      correctOrder: correctOrder,
      createdAt: widget.initialData?.createdAt, // Giữ ngày tạo cũ
    );

    widget.onSave(question);
  }
}