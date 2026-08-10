import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_utils.dart';
import '../../domain/entities/tokoh_entity.dart';
import '../../domain/repositories/demografi_repository.dart';
import '../datasources/demografi_remote_datasource.dart';
import '../models/tokoh_model.dart';

class DemografiRepositoryImpl implements DemografiRepository {
  final DemografiRemoteDatasource remoteDatasource;

  DemografiRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<TokohEntity>>> getTokohList() async {
    try {
      final list = await remoteDatasource.getTokohList();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity) async {
    try {
      final model = TokohModel.fromEntity(entity);
      final result = await remoteDatasource.addTokoh(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
