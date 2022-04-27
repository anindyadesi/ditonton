import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class GetTvRecommendations {
  final MovieRepository repository;
  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
