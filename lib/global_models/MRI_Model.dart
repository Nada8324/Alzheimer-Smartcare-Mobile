import 'dart:io';

class MRIModel {
  File? image;
  String? confidence;
  String? predictedClass;

  MRIModel({
    this.image,
    this.confidence,
    this.predictedClass,
  });

  // Factory constructor to create an instance from JSON
  factory MRIModel.fromJson(Map<String, dynamic> json) {
    return MRIModel(
      confidence: (json['confidence'])?.toString(),
      predictedClass: json['predicted_class']?.toString(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
    };
  }
}
