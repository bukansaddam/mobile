import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final authModel = await remoteDatasource.login(
        username: username,
        password: password,
      );

      // Save token and user data locally
      await localDatasource.saveToken(authModel.accessToken);
      await localDatasource.saveUser(authModel.user);

      return Right(authModel.toEntity());
    } catch (e) {
      final cleanMessage = e.toString().replaceAll('Exception: ', '');
      return Left(ServerFailure(cleanMessage));
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
      );

      // Save token and user data locally if available upon registration
      if (authModel.accessToken.isNotEmpty) {
        await localDatasource.saveToken(authModel.accessToken);
        await localDatasource.saveUser(authModel.user);
      }

      return Right(authModel.toEntity());
    } catch (e) {
      final cleanMessage = e.toString().replaceAll('Exception: ', '');
      return Left(ServerFailure(cleanMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getSavedUser() async {
    try {
      final userModel = await localDatasource.getUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure("Failed to retrieve cached user data"));
    }
  }

  @override
  Future<Either<Failure, String?>> getSavedToken() async {
    try {
      final token = await localDatasource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure("Failed to retrieve cached token"));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDatasource.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to clear local session"));
    }
  }
}
