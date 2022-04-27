import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/movie.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBlocPlaying extends Bloc<MovieListEvent, MovieListStatePlaying> {
  final GetNowPlayingMovies getNowPlayingMovies;

  MovieListBlocPlaying({
    required this.getNowPlayingMovies,
  }) : super(MovieListStatePlaying.initial()) {
    on<OnGetNowPlayingMovies>((event, emit) async {
      emit(state.copyWith(
          nowPlayingMoviesState: RequestState.Loading, message: ''));
      final nowPlayingResult = await getNowPlayingMovies.execute();

      nowPlayingResult.fold((failure) async {
        emit(state.copyWith(
            nowPlayingMoviesState: RequestState.Error,
            message: failure.message));
      }, (movies) async {
        emit(state.copyWith(
            nowPlayingMoviesState: RequestState.Loaded,
            nowPlayingMovies: movies));
      });
    });
  }
}

class MovieListBlocPopular extends Bloc<MovieListEvent, MovieListStatePopular> {
  final GetPopularMovies getPopularMovies;

  MovieListBlocPopular({
    required this.getPopularMovies,
  }) : super(MovieListStatePopular.initial()) {
    on<OnGetPopularMovies>((event, emit) async {
      emit(state.copyWith(
          popularMoviesState: RequestState.Loading, message: ''));
      final popularResult = await getPopularMovies.execute();

      popularResult.fold((failure) async {
        emit(state.copyWith(
            popularMoviesState: RequestState.Error, message: failure.message));
      }, (movies) async {
        emit(state.copyWith(
            popularMoviesState: RequestState.Loaded, popularMovies: movies));
      });
    });
  }
}

class MovieListBlocTopRated
    extends Bloc<MovieListEvent, MovieListStateTopRated> {
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBlocTopRated({
    required this.getTopRatedMovies,
  }) : super(MovieListStateTopRated.initial()) {
    on<OnGetTopRatedMovies>((event, emit) async {
      emit(state.copyWith(
          topRatedMoviesState: RequestState.Loading, message: ''));
      final topRatedResult = await getTopRatedMovies.execute();

      topRatedResult.fold((failure) async {
        emit(state.copyWith(
            topRatedMoviesState: RequestState.Error, message: failure.message));
      }, (movies) async {
        emit(state.copyWith(
            topRatedMoviesState: RequestState.Loaded, topRatedMovies: movies));
      });
    });
  }
}
