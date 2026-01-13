class SetModel {
  final String id; // Trường duy nhất không được null
  final String? name;
  final int? questionCount;
  final DateTime? createdAt;

  SetModel({required this.id, this.name, this.questionCount, this.createdAt});

  // Chuyển từ JSON sang Object
  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id']?.toString() ?? '', // Đảm bảo luôn có id
      name: json['name'],
      questionCount: json['questionCount'] is int
          ? json['questionCount']
          : int.tryParse(json['questionCount']?.toString() ?? ''),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  // Chuyển từ Object sang JSON (Dùng khi gửi request update/create)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questionCount': questionCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
