import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_planner/common/local_storage/local_storage.dart';
import 'package:task_planner/models/profile_model.dart';
import 'package:task_planner/repositories/profile_repository.dart';

const kProfileStorageKey = 'profile';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required this.localStorage,
  });

  @protected
  final LocalStorage localStorage;

  @override
  Future<ProfileModel?> getProfile() async {
    ProfileModel? profile;
    final data = await localStorage.getData(kProfileStorageKey);

    if (data != null) {
      profile = ProfileModel.fromJson(jsonDecode(data));
    }

    return profile;
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    localStorage.saveData(
      kProfileStorageKey,
      jsonEncode(profile.toJson()),
    );
  }
}
