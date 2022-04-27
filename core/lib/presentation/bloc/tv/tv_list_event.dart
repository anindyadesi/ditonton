part of 'tv_list_bloc.dart';

abstract class TvListEvent extends Equatable {
  TvListEvent();

  @override
  List<Object> get props => [];
}

class OnGetNowPlayingTvs extends TvListEvent {
  OnGetNowPlayingTvs();

  @override
  List<Object> get props => [];
}

class OnGetPopularTvs extends TvListEvent {
  OnGetPopularTvs();

  @override
  List<Object> get props => [];
}

class OnGetTopRatedTvs extends TvListEvent {
  OnGetTopRatedTvs();

  @override
  List<Object> get props => [];
}
