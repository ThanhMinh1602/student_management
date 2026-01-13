class ClassRequest {
  final String name;

  ClassRequest({required this.name});

  Map<String, dynamic> toJson() => {"name": name};
}
