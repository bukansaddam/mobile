import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/domain/entities/auth_mapper.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const Duration _sessionLifetime = Duration(hours: 12);

  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final SurveyLocalDatasource? surveyLocalDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    this.surveyLocalDatasource,
  });

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
    String? deviceId,
  }) async {
    try {
      final authModel = await remoteDatasource.login(
        username: username,
        password: password,
        deviceId: deviceId,
      );

      await _saveSession(authModel);

      final isQuizCompleted =
          (authModel.isInitialQuizCompleted == true) ||
          (authModel.user.isInitialQuizCompleted == true) ||
          (authModel.isInitialQuizFilled == true) ||
          (authModel.user.isInitialQuizFilled == true);
      if (surveyLocalDatasource != null) {
        await surveyLocalDatasource!.setInitialSurveyCompleted(
          authModel.user.id,
          isQuizCompleted,
        );
      }

      return Right(authModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String phoneNumber,
    required String nik,
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceId,
  }) async {
    try {
      final authModel = await remoteDatasource.register(
        name: name,
        phoneNumber: phoneNumber,
        nik: nik,
        longitude: longitude,
        latitude: latitude,
        username: username,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        deviceId: deviceId,
      );

      if (authModel.accessToken.isNotEmpty) {
        await _saveSession(authModel);
      }

      return Right(authModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getSavedUser() async {
    try {
      final userModel = await localDatasource.getUser();
      if (userModel != null && surveyLocalDatasource != null) {
        final isQuizCompleted =
            (userModel.isInitialQuizCompleted == true) ||
            (userModel.isInitialQuizFilled == true);
        await surveyLocalDatasource!.setInitialSurveyCompleted(
          userModel.id,
          isQuizCompleted,
        );
      }
      return Right(userModel?.toDomain());
    } catch (e) {
      return const Left(CacheFailure("Failed to retrieve cached user data"));
    }
  }

  @override
  Future<Either<Failure, String?>> getSavedToken() async {
    try {
      final token = await localDatasource.getToken();
      return Right(token);
    } catch (e) {
      return const Left(CacheFailure("Failed to retrieve cached token"));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken() async {
    try {
      final refreshToken = await localDatasource.getRefreshToken();
      final lastActivity = await localDatasource.getLastActivityAt();
      final expired =
          lastActivity == null ||
          DateTime.now().difference(lastActivity) >= _sessionLifetime;

      // Server memperpanjang sesi tiap request, jadi refresh hanya saat idle 12 jam.
      if (!expired || refreshToken == null || refreshToken.isEmpty) {
        final user = await localDatasource.getUser();
        final token = await localDatasource.getToken();
        if (user == null || token == null) {
          return const Left(CacheFailure('Sesi tersimpan tidak lengkap'));
        }
        return Right(AuthEntity(user: user.toDomain(), accessToken: token));
      }

      final authModel = await remoteDatasource
          .refreshToken(refreshToken)
          // Batasi agar splash tidak menunggu melewati batas waktunya.
          .timeout(const Duration(seconds: 8));
      await _saveSession(authModel);
      return Right(authModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDatasource.clearSession();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure("Failed to clear local session"));
    }
  }

  Future<void> _saveSession(AuthModel authModel) async {
    await localDatasource.saveToken(authModel.accessToken);
    final refreshToken = authModel.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await localDatasource.saveRefreshToken(refreshToken);
    }
    await localDatasource.saveUser(authModel.user);
  }
}
