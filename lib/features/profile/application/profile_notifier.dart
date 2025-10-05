// features/profile/application/profile_notifier.dart
import 'dart:io';
import 'package:cole20/features/profile/domain/repository/i_profile_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final IProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState.initial()){
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state = ProfileState.loading();
    try {
      final res = await _repository.fetchProfile();
      state = ProfileState.loaded(res.user);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }


  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String gender,
    File? image,
  }) async {
    state = state.copyWith(status: ProfileStatus.updating);
    try {
      final updatedProfile =
          await _repository.updateProfile(fullName, phone, gender, image);
      state = ProfileState.loaded(updatedProfile.user);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }



  Future<void> changePassword(String oldPassword,String newPassword) async {
    state = ProfileState.changingPassword();
    try {
      final response= await _repository.changePassword(oldPassword,newPassword);
      state = ProfileState.loaded(response.user);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }




}
