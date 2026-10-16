import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';
import 'package:akar/utils/app_logger.dart';

abstract class ProfileRemoteDatasource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(UpdateProfileParams params);
}

class ProfileRemoteDatasourceImpl extends BaseRemoteDataSource
    implements ProfileRemoteDatasource {
  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await handleRequest<UserModel>(
        () => dio.get(ApiConstants.me),
        fromJson: _parseUserModel,
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Gagal memuat profil pengguna');
      }
    } on DioException catch (e) {
      AppLogger.e('[PROFILE_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[PROFILE_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<UserModel> updateProfile(UpdateProfileParams params) async {
    try {
      dynamic requestData;
      Options? options;

      final map = <String, dynamic>{};
      if (params.name != null && params.name!.trim().isNotEmpty) {
        map['name'] = params.name!.trim();
      }
      if (params.username != null && params.username!.trim().isNotEmpty) {
        map['username'] = params.username!.trim();
      }
      if (params.email != null && params.email!.trim().isNotEmpty) {
        map['email'] = params.email!.trim();
      }
      if (params.phone != null && params.phone!.trim().isNotEmpty) {
        map['phone'] = params.phone!.trim();
      }
      if (params.nik != null && params.nik!.trim().isNotEmpty) {
        map['nik'] = params.nik!.trim();
      }
      if (params.birthDate != null && params.birthDate!.trim().isNotEmpty) {
        map['birth_date'] = params.birthDate!.trim();
      }
      if (params.address != null && params.address!.trim().isNotEmpty) {
        map['address'] = params.address!.trim();
      }
      if (params.password != null && params.password!.isNotEmpty) {
        map['password'] = params.password!;
      }
      if (params.passwordConfirmation != null &&
          params.passwordConfirmation!.isNotEmpty) {
        map['password_confirmation'] = params.passwordConfirmation!;
      }
      if (params.currentPassword != null &&
          params.currentPassword!.isNotEmpty) {
        map['current_password'] = params.currentPassword!;
      }

      if (params.profilePic != null) {
        final compressed = await ImageCompressHelper.compressToWebp(
          params.profilePic!,
        );
        final fileName = compressed.path.split('/').last;
        map['profile_pic'] = await MultipartFile.fromFile(
          compressed.path,
          filename: fileName,
        );
        map['_method'] = 'PATCH';
        requestData = FormData.fromMap(map);
        options = Options(contentType: 'multipart/form-data');
      } else {
        requestData = map;
      }

      final response = await handleRequest<UserModel>(
        () => dio.patch(ApiConstants.me, data: requestData, options: options),
        fromJson: _parseUserModel,
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(
          response.message ?? 'Gagal memperbarui profil pengguna',
        );
      }
    } on DioException catch (e) {
      AppLogger.e('[PROFILE_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[PROFILE_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  UserModel _parseUserModel(dynamic json) {
    if (json is Map) {
      Map<String, dynamic> map = Map<String, dynamic>.from(json);
      if (map['user'] is Map) {
        map = Map<String, dynamic>.from(map['user'] as Map);
      }
      if (map['nik'] == null) {
        if (map['public_member'] is Map &&
            map['public_member']['nik'] != null) {
          map['nik'] = map['public_member']['nik'];
        } else if (map['village_member'] is Map &&
            map['village_member']['nik'] != null) {
          map['nik'] = map['village_member']['nik'];
        }
      }
      if (map['name'] == null) {
        if (map['public_member'] is Map &&
            map['public_member']['name'] != null) {
          map['name'] = map['public_member']['name'];
        } else if (map['village_member'] is Map &&
            map['village_member']['name'] != null) {
          map['name'] = map['village_member']['name'];
        }
      }
      if (map['address'] == null) {
        if (map['public_member'] is Map &&
            map['public_member']['address'] != null) {
          map['address'] = map['public_member']['address'];
        }
      }
      if (map['birth_date'] == null) {
        if (map['public_member'] is Map &&
            map['public_member']['birth_date'] != null) {
          map['birth_date'] = map['public_member']['birth_date'];
        }
      }
      if (map['profile_pic'] == null) {
        if (map['public_member'] is Map &&
            map['public_member']['profile_pic'] != null) {
          map['profile_pic'] = map['public_member']['profile_pic'];
        }
      }
      return UserModel.fromJson(map);
    }
    throw const FormatException('Format data profil tidak sesuai');
  }
}
