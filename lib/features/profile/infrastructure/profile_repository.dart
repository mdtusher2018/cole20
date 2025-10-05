// features/profile/infrastructure/profile_repository.dart
import 'dart:io';

import 'package:cole20/core/api/i_api_service.dart';
import 'package:cole20/core/apiEndPoints.dart';
import 'package:cole20/features/profile/domain/repository/i_profile_repository.dart';
import 'package:cole20/features/profile/domain/response_model/change_password.dart';
import 'package:cole20/features/profile/domain/response_model/profile_response.dart';
import 'package:cole20/features/profile/domain/response_model/update_profile_response.dart';

class ProfileRepository implements IProfileRepository {
  final IApiService _api;

  ProfileRepository(this._api);

  @override
  Future<ProfileResponse> fetchProfile() async {
    // adjust ApiEndpoints.getProfile to your actual endpoint constant
    final res = await _api.get(ApiEndpoints.getProfile);
    // response shape expected: { success, statusCode, message, data: { user: {...} } }
    return ProfileResponse.fromJson(res);
  }

  @override
  Future<UpdateProfileResponse> updateProfile(
    String fullName,
    String phone,
    String gender,
    File? image,
  ) async {
    // adjust ApiEndpoints.getProfile to your actual endpoint constant
    final res = await _api.multipart(
      ApiEndpoints.updateProfile,
      method: "PATCH",
      body: {
        "fullName": fullName,
        "phone": phone,
        "gender": gender.toLowerCase(),
      },

      files: {if (image != null) "image": image},
    );
    // response shape expected: { success, statusCode, message, data: { user: {...} } }
    return UpdateProfileResponse.fromJson(res);
  }

  @override
  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword) async {
    final response= await _api.patch(ApiEndpoints.changePassword, {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });
    return ChangePasswordResponse.fromJson(response);
  }


}
