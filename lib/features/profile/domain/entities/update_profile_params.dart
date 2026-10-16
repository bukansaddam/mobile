import 'dart:io';

class UpdateProfileParams {
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? nik;
  final String? birthDate;
  final String? address;
  final File? profilePic;
  final String? password;
  final String? passwordConfirmation;
  final String? currentPassword;

  const UpdateProfileParams({
    this.name,
    this.username,
    this.email,
    this.phone,
    this.nik,
    this.birthDate,
    this.address,
    this.profilePic,
    this.password,
    this.passwordConfirmation,
    this.currentPassword,
  });
}
