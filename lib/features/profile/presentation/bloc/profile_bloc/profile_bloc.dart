import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';
import 'package:akar/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:akar/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final AuthBloc? authBloc;

  ProfileBloc({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
    this.authBloc,
  }) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      final currentUser = _resolveCurrentUser();
      emit(ProfileLoading(user: currentUser));

      final result = await getProfileUsecase();
      result.fold(
        (failure) => emit(ProfileError(failure.message, user: currentUser)),
        (user) {
          authBloc?.add(UpdateAuthUserEvent(user));
          emit(ProfileLoaded(user));
        },
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      final currentUser = _resolveCurrentUser();
      emit(ProfileUpdating(user: currentUser));

      final result = await updateProfileUsecase(event.params);
      result.fold(
        (failure) =>
            emit(ProfileUpdateError(failure.message, user: currentUser)),
        (updatedUser) {
          authBloc?.add(UpdateAuthUserEvent(updatedUser));
          emit(
            ProfileUpdateSuccess(
              updatedUser,
              message: 'Profil berhasil diperbarui',
            ),
          );
        },
      );
    });

    on<ClearProfileStatusEvent>((event, emit) {
      final currentUser = _resolveCurrentUser();
      if (currentUser != null) {
        emit(ProfileLoaded(currentUser));
      } else {
        emit(ProfileInitial());
      }
    });
  }

  UserEntity? _resolveCurrentUser() {
    if (state.user != null) return state.user;
    final currentAuthState = authBloc?.state;
    if (currentAuthState is AuthAuthenticated) {
      return currentAuthState.user;
    }
    return null;
  }
}
