import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_planner/models/profile_model.dart';
import 'package:task_planner/repositories/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({required this.repository});

  final ProfileRepository repository;

  ProfileModel profile = ProfileModel(
    name: 'Your Name',
    occupation: 'Your Occupation',
  );

  Future<void> init() async {
    final result = await repository.getProfile();

    if (result != null) {
      profile = result;
      notifyListeners();
    }
  }

  Future<void> updateProfile(ProfileModel result) async {
    profile.name = result.name;
    profile.occupation = result.occupation;
    profile.imagePath = result.imagePath;

    await repository.updateProfile(profile);

    notifyListeners();
  }

  ImageProvider? get profileImage {
    FileImage? image;
    if (profile.imagePath != null) {
      image = FileImage(File(profile.imagePath!));
    }
    return image;
  }
}
