part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class OnGetMovieDetail extends DetailEvent {
  final int id;

  OnGetMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class OnGetMovieRecommendation extends DetailEvent {
  final int id;

  OnGetMovieRecommendation(this.id);

  @override
  List<Object> get props => [id];
}

class OnGetWatchlistStatus extends DetailEvent {
  final int id;

  OnGetWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnRemoveWatchlist extends DetailEvent {
  final MovieDetail movie;
  final int option;
  OnRemoveWatchlist(this.movie, this.option);

  @override
  List<Object> get props => [movie, option];
}

class OnSaveWatchlist extends DetailEvent {
  final MovieDetail movie;
  final int option;
  OnSaveWatchlist(this.movie, this.option);

  @override
  List<Object> get props => [movie, option];
}
