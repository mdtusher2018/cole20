import 'dart:io';

import 'package:cole20/features/profile/domain/response_model/about_response.dart';
import 'package:cole20/features/profile/domain/response_model/change_password.dart';
import 'package:cole20/features/profile/domain/response_model/profile_response.dart';
import 'package:cole20/features/profile/domain/response_model/ritual_progress_model.dart';
import 'package:cole20/features/profile/domain/response_model/update_profile_response.dart';

abstract class IProfileRepository {
  Future<ProfileResponse> fetchProfile();

  Future<UpdateProfileResponse> updateProfile(
    String fullName,
    String phone,
    String gender,
    File? image,
  );

  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword);


  Future<List<RitualProgressCategory>> fetchRitualProgress();

  Future<AboutResponse> fetchAbout();
}
