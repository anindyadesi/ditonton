import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';

class GetNowPlayingTvs {
  final MovieRepository repository;

  GetNowPlayingTvs(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingTv();
  }
}
