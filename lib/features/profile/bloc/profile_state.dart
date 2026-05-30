import '../../../data/models/user_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
