import 'package:cole20/features/auth/domain/user_model.dart';
import 'package:cole20/features/profile/domain/response_model/about_response.dart';
import 'package:cole20/features/profile/domain/response_model/ritual_progress_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
  updating,
  changingPassword,
}

class ProfileState {
  final ProfileStatus status;
  final User? profile;
  final List<RitualProgressCategory> ritualProgress;
  final AboutResponse? about;  // <-- new
  final String? errorMessage;

  const ProfileState._({
    required this.status,
    this.profile,
    this.errorMessage,
    this.ritualProgress = const [],
    this.about, // <-- new
  });

  ProfileState copyWith({
    ProfileStatus? status,
    User? profile,
    List<RitualProgressCategory>? ritualProgress,
    AboutResponse? about,
    String? errorMessage,
  }) {
    return ProfileState._(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      ritualProgress: ritualProgress ?? this.ritualProgress,
      about: about ?? this.about, // <-- new
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProfileState.initial() =>
      const ProfileState._(status: ProfileStatus.initial);
  factory ProfileState.loading() =>
      const ProfileState._(status: ProfileStatus.loading);
  factory ProfileState.updating() =>
      const ProfileState._(status: ProfileStatus.updating);
  factory ProfileState.changingPassword() =>
      const ProfileState._(status: ProfileStatus.changingPassword);
  factory ProfileState.loaded(User profile) =>
      ProfileState._(status: ProfileStatus.loaded, profile: profile);

  factory ProfileState.error(String message) =>
      ProfileState._(status: ProfileStatus.error, errorMessage: message);

  bool get isInitial => status == ProfileStatus.initial;
  bool get isLoading => status == ProfileStatus.loading;
  bool get isUpdating => status == ProfileStatus.updating;
  bool get isChanging => status == ProfileStatus.changingPassword;
  bool get isLoaded => status == ProfileStatus.loaded;
  bool get hasError => status == ProfileStatus.error;
}
