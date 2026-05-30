import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../data/models/user_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
  }

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      // TODO: fetch from repository
      emit(const ProfileLoaded(UserModel(id: '1', name: 'John Doe', email: 'john@example.com')));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      // TODO: update via repository
      emit(ProfileLoaded(UserModel(id: '1', name: event.name, email: event.email)));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
