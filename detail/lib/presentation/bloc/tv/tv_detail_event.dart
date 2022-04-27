part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  TvDetailEvent();

  @override
  List<Object> get props => [];
}

class OnGetTvDetail extends TvDetailEvent {
  final int id;
  OnGetTvDetail(this.id);
  @override
  List<Object> get props => [id];
}

class OnGetTvRecommendation extends TvDetailEvent {
  final int id;

  OnGetTvRecommendation(this.id);

  @override
  List<Object> get props => [id];
}

class OnGetTvWatchlistStatus extends TvDetailEvent {
  final int id;

  OnGetTvWatchlistStatus(this.id);

  @override
  List<Object> get props => [];
}

class OnTvRemoveWatchlist extends TvDetailEvent {
  final MovieDetail movie;
  final int option;
  OnTvRemoveWatchlist(this.movie, this.option);

  @override
  List<Object> get props => [movie, option];
}

class OnTvSaveWatchlist extends TvDetailEvent {
  final MovieDetail movie;
  final int option;
  OnTvSaveWatchlist(this.movie, this.option);

  @override
  List<Object> get props => [movie, option];
}
