import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/domain/entities/auth_mapper.dart';
import 'package:akar/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';
import 'package:akar/features/profile/domain/repositories/profile_repository.dart';
import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final SurveyLocalDatasource? surveyLocalDatasource;

  ProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    this.surveyLocalDatasource,
  });

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userModel = await remoteDatasource.getProfile();
      await localDatasource.saveUser(userModel);

      final isQuizCompleted =
          (userModel.isInitialQuizCompleted == true) ||
          (userModel.isInitialQuizFilled == true);
      if (surveyLocalDatasource != null) {
        await surveyLocalDatasource!.setInitialSurveyCompleted(
          userModel.id,
          isQuizCompleted,
        );
      }

      return Right(userModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    try {
      final userModel = await remoteDatasource.updateProfile(params);
      await localDatasource.saveUser(userModel);

      final isQuizCompleted =
          (userModel.isInitialQuizCompleted == true) ||
          (userModel.isInitialQuizFilled == true);
      if (surveyLocalDatasource != null) {
        await surveyLocalDatasource!.setInitialSurveyCompleted(
          userModel.id,
          isQuizCompleted,
        );
      }

      return Right(userModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
