part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  UserEntity? get user => null;

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  @override
  final UserEntity? user;

  const ProfileLoading({this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileLoaded extends ProfileState {
  @override
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  @override
  final UserEntity? user;

  const ProfileError(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class ProfileUpdating extends ProfileState {
  @override
  final UserEntity? user;

  const ProfileUpdating({this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  @override
  final UserEntity user;
  final String message;

  const ProfileUpdateSuccess(
    this.user, {
    this.message = 'Profil berhasil diperbarui',
  });

  @override
  List<Object?> get props => [user, message];
}

class ProfileUpdateError extends ProfileState {
  final String message;
  @override
  final UserEntity? user;

  const ProfileUpdateError(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}
