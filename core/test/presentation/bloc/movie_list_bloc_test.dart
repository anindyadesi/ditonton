import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:core/domain/usecases/tv/get_popular_tvs.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetTopRatedTvs,
  GetNowPlayingTvs,
  GetPopularTvs
])
void main() {
  late MovieListBlocPlaying movieListBlocPlaying;
  late MovieListBlocTopRated movieListBlocTopRated;
  late MovieListBlocPopular movieListBlocPopular;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBlocPlaying =
        MovieListBlocPlaying(getNowPlayingMovies: mockGetNowPlayingMovies);
    movieListBlocPopular =
        MovieListBlocPopular(getPopularMovies: mockGetPopularMovies);
    movieListBlocTopRated =
        MovieListBlocTopRated(getTopRatedMovies: mockGetTopRatedMovies);
  });
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  final tTv = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Movie>[tTv];

  //movies

  test('initial state now playing should be empty', () {
    expect(
        movieListBlocPlaying.state.nowPlayingMoviesState, RequestState.Empty);
  });

  blocTest<MovieListBlocPlaying, MovieListStatePlaying>(
      'should emit [movieliststate.Loading,movieliststate.Loaded,'
      'when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBlocPlaying;
      },
      act: (bloc) => bloc.add(OnGetNowPlayingMovies()),
      expect: () => [
            MovieListStatePlaying.initial()
                .copyWith(nowPlayingMoviesState: RequestState.Loading),
            MovieListStatePlaying.initial().copyWith(
                nowPlayingMovies: tMovieList,
                nowPlayingMoviesState: RequestState.Loaded,
                message: ''),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      });

  blocTest<MovieListBlocPlaying, MovieListStatePlaying>(
      'Should emit [Loading,Error] when get now playing movies is unsuccessfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBlocPlaying;
      },
      act: (bloc) => bloc.add(OnGetNowPlayingMovies()),
      expect: () => [
            MovieListStatePlaying.initial()
                .copyWith(nowPlayingMoviesState: RequestState.Loading),
            MovieListStatePlaying.initial().copyWith(
                nowPlayingMoviesState: RequestState.Error,
                message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      });

  test('initial state popular should be empty', () {
    expect(movieListBlocPopular.state.popularMoviesState, RequestState.Empty);
  });
  blocTest<MovieListBlocPopular, MovieListStatePopular>(
      'should emit [popularMoviesState.Loading,popularMoviesState.Loaded,'
      'when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBlocPopular;
      },
      act: (bloc) => bloc.add(OnGetPopularMovies()),
      expect: () => [
            MovieListStatePopular.initial()
                .copyWith(popularMoviesState: RequestState.Loading),
            MovieListStatePopular.initial().copyWith(
                popularMovies: tMovieList,
                popularMoviesState: RequestState.Loaded,
                message: ''),
          ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });

  blocTest<MovieListBlocPopular, MovieListStatePopular>(
      'Should emit [Loading,Error] when get popular movies is unsuccessfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBlocPopular;
      },
      act: (bloc) => bloc.add(OnGetPopularMovies()),
      expect: () => [
            MovieListStatePopular.initial()
                .copyWith(popularMoviesState: RequestState.Loading),
            MovieListStatePopular.initial().copyWith(
                popularMoviesState: RequestState.Error,
                message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });

  test('initial state Top Rated should be empty', () {
    expect(movieListBlocTopRated.state.topRatedMoviesState, RequestState.Empty);
  });
  blocTest<MovieListBlocTopRated, MovieListStateTopRated>(
      'should emit [topRatedMoviesState.Loading,topRatedMoviesState.Loaded,'
      'when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBlocTopRated;
      },
      act: (bloc) => bloc.add(OnGetTopRatedMovies()),
      expect: () => [
            MovieListStateTopRated.initial()
                .copyWith(topRatedMoviesState: RequestState.Loading),
            MovieListStateTopRated.initial().copyWith(
                topRatedMovies: tMovieList,
                topRatedMoviesState: RequestState.Loaded,
                message: ''),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      });

  blocTest<MovieListBlocTopRated, MovieListStateTopRated>(
      'Should emit [Loading,Error] when get top rated movies is unsuccessfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBlocTopRated;
      },
      act: (bloc) => bloc.add(OnGetTopRatedMovies()),
      expect: () => [
            MovieListStateTopRated.initial()
                .copyWith(topRatedMoviesState: RequestState.Loading),
            MovieListStateTopRated.initial().copyWith(
                topRatedMoviesState: RequestState.Error,
                message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      });
}
