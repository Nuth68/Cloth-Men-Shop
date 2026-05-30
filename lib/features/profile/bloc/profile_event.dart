abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  const UpdateProfile({required this.name, required this.email});
}
