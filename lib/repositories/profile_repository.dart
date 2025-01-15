import 'package:task_planner/models/profile_model.dart';

abstract interface class ProfileRepository {
  Future<ProfileModel?> getProfile();
  Future<void> updateProfile(ProfileModel profile);
}
