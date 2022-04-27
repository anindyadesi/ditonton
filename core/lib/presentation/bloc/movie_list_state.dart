part of 'movie_list_bloc.dart';

class MovieListStatePlaying extends Equatable {
  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingMoviesState;

  final String message;

  MovieListStatePlaying(
      {required this.nowPlayingMovies,
      required this.nowPlayingMoviesState,
      required this.message});

  MovieListStatePlaying copyWith(
      {List<Movie>? nowPlayingMovies,
      RequestState? nowPlayingMoviesState,
      String? message}) {
    return MovieListStatePlaying(
        nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
        nowPlayingMoviesState:
            nowPlayingMoviesState ?? this.nowPlayingMoviesState,
        message: message ?? this.message);
  }

  factory MovieListStatePlaying.initial() => MovieListStatePlaying(
      nowPlayingMovies: [],
      nowPlayingMoviesState: RequestState.Empty,
      message: '');

  @override
  // TODO: implement props
  List<Object?> get props => [nowPlayingMovies, nowPlayingMoviesState, message];
}

class MovieListStatePopular extends Equatable {
  final List<Movie> popularMovies;
  final RequestState popularMoviesState;

  final String message;

  MovieListStatePopular(
      {required this.popularMovies,
      required this.popularMoviesState,
      required this.message});

  MovieListStatePopular copyWith(
      {List<Movie>? popularMovies,
      RequestState? popularMoviesState,
      String? message}) {
    return MovieListStatePopular(
        popularMovies: popularMovies ?? this.popularMovies,
        popularMoviesState: popularMoviesState ?? this.popularMoviesState,
        message: message ?? this.message);
  }

  factory MovieListStatePopular.initial() => MovieListStatePopular(
      popularMovies: [], popularMoviesState: RequestState.Empty, message: '');

  @override
  // TODO: implement props
  List<Object?> get props => [popularMovies, popularMoviesState, message];
}

class MovieListStateTopRated extends Equatable {
  final List<Movie> topRatedMovies;
  final RequestState topRatedMoviesState;

  final String message;

  MovieListStateTopRated(
      {required this.topRatedMovies,
      required this.topRatedMoviesState,
      required this.message});

  MovieListStateTopRated copyWith(
      {List<Movie>? topRatedMovies,
      RequestState? topRatedMoviesState,
      String? message}) {
    return MovieListStateTopRated(
        topRatedMovies: topRatedMovies ?? this.topRatedMovies,
        topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
        message: message ?? this.message);
  }

  factory MovieListStateTopRated.initial() => MovieListStateTopRated(
      topRatedMovies: [], topRatedMoviesState: RequestState.Empty, message: '');

  @override
  // TODO: implement props
  List<Object?> get props => [topRatedMovies, topRatedMoviesState, message];
}
