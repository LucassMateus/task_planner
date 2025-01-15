import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:task_planner/common/local_storage/local_storage.dart';
import 'package:task_planner/models/profile_model.dart';

const kProfileStorageKey = 'profile';

class ProfileController extends ChangeNotifier {
  ProfileController({required this.localStorage});

  @protected
  final LocalStorage localStorage;

  ProfileModel profile = ProfileModel(
    name: 'Your Name',
    occupation: 'Your Occupation',
  );

  Future<void> init() async {
    final data = await localStorage.getData(kProfileStorageKey);

    if (data != null) {
      profile = ProfileModel.fromJson(jsonDecode(data));
    }

    notifyListeners();
  }

  Future<void> updateProfile(ProfileModel result) async {
    profile.name = result.name;
    profile.occupation = result.occupation;
    profile.imagePath = result.imagePath;

    await localStorage.saveData(
      kProfileStorageKey,
      jsonEncode(profile.toJson()),
    );

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
