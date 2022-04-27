import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';

class GetPopularTvs {
  final MovieRepository repository;

  GetPopularTvs(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularTv();
  }
}
