import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class SearchTvs {
  final MovieRepository repository;

  SearchTvs(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchTv(query);
  }
}
