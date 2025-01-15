import 'dart:io';

import 'package:flutter/material.dart';

class ProfileModel {
  String name;
  String occupation;
  String? imagePath;

  ProfileModel({
    required this.name,
    required this.occupation,
    this.imagePath,
  });

  FileImage? get image {
    if (imagePath != null) {
      return FileImage(File(imagePath!));
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'occupation': occupation,
      'imageFile': imagePath,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      occupation: json['occupation'],
      imagePath: json['imageFile'],
    );
  }
}
