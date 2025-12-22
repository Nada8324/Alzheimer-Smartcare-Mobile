class Face {
  final String name;
  final String imageBase64;

  Face({required this.name, required this.imageBase64});

  factory Face.fromJson(Map<String, dynamic> json) {
    return Face(
      name: json['name'],
      imageBase64: json['base64Image'],
    );
  }
}