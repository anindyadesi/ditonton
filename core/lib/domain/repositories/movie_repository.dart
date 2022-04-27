import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  Future<Either<Failure, List<Movie>>> getNowPlayingTv();
  Future<Either<Failure, List<Movie>>> getPopularTv();
  Future<Either<Failure, List<Movie>>> getTopRatedTv();
  Future<Either<Failure, MovieDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Movie>>> getTvRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchTv(String query);

  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie, int option);
  Future<Either<Failure, String>> removeWatchlist(
      MovieDetail movie, int option);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<List<dynamic>>>> getWatchlistMovies();
}