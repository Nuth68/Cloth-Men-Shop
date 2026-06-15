import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
  }

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final loggedIn = await _repository.isLoggedIn();
      if (!loggedIn) {
        emit(const ProfileUnauthenticated());
        return;
      }
      final user = await _repository.getCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('401') ||
          msg.contains('Unauthorized') ||
          msg.contains('No token') ||
          msg.contains('Timeout')) {
        emit(const ProfileUnauthenticated());
      } else {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdate(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final user = await _repository.getCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}