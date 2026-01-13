class SetRequest {
  final String name;

  SetRequest({required this.name});

  Map<String, dynamic> toJson() => {"name": name};
}
