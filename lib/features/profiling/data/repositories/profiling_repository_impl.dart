import '../../../../core/errors/failures.dart';
import '../../domain/entities/tokoh_entity.dart';
import '../../domain/repositories/profiling_repository.dart';
import '../datasources/profiling_remote_datasource.dart';
import '../models/tokoh_model.dart';

class ProfilingRepositoryImpl implements ProfilingRepository {
  final ProfilingRemoteDatasource remoteDatasource;

  ProfilingRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<TokohEntity>>> getTokohList() async {
    try {
      final list = await remoteDatasource.getTokohList();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity) async {
    try {
      final model = TokohModel.fromEntity(entity);
      final result = await remoteDatasource.addTokoh(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
