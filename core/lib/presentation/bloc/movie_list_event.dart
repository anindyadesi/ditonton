part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  MovieListEvent();

  @override
  List<Object> get props => [];
}

class OnGetNowPlayingMovies extends MovieListEvent {
  OnGetNowPlayingMovies();

  @override
  List<Object> get props => [];
}

class OnGetPopularMovies extends MovieListEvent {
  OnGetPopularMovies();

  @override
  List<Object> get props => [];
}

class OnGetTopRatedMovies extends MovieListEvent {
  OnGetTopRatedMovies();

  @override
  List<Object> get props => [];
}
