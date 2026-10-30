import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_remote_datasource.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_mapper.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_mapper.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';
import 'package:dio/dio.dart';

class ActivationRepositoryImpl implements ActivationRepository {
  final ActivationRemoteDatasource remoteDatasource;

  ActivationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ActivationRunEntity>>> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  }) async {
    try {
      final responseModel = await remoteDatasource.getActivationRuns(
        page: page,
        perPage: perPage,
        status: status,
      );
      final entities = responseModel.data.map((m) => m.toDomain()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<ActivationSubmissionEntity>>>
  getActivationSubmissions({required String participantId}) async {
    try {
      final models = await remoteDatasource.getActivationSubmissions(
        participantId: participantId,
      );
      return Right(models.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ActivationSubmissionEntity>> submitActivationReport({
    required String participantId,
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) async {
    try {
      final responseModel = await remoteDatasource.submitActivationReport(
        participantId: participantId,
        attachments: attachments,
        notes: notes,
        receiverNik: receiverNik,
        receiverName: receiverName,
      );
      return Right(responseModel.toDomain());
    } on FileSecurityException catch (e) {
      return Left(ValidationFailure(e.message));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ErrorUtils.parseErrorMessage(e),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
