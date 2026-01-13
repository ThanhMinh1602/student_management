class AssignStudentRequest {
  final String classId;

  AssignStudentRequest({required this.classId});

  Map<String, dynamic> toJson() => {"classId": classId};
}
