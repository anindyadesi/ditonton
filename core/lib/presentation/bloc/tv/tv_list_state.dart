part of 'tv_list_bloc.dart';

class TvListStatePlaying extends Equatable {
  final List<Movie> nowPlayingTvs;
  final RequestState nowPlayingTvsState;

  final String message;

  TvListStatePlaying(
      {required this.nowPlayingTvs,
      required this.nowPlayingTvsState,
      required this.message});

  TvListStatePlaying copyWith(
      {List<Movie>? nowPlayingTvs,
      RequestState? nowPlayingTvsState,
      String? message}) {
    return TvListStatePlaying(
        nowPlayingTvs: nowPlayingTvs ?? this.nowPlayingTvs,
        nowPlayingTvsState: nowPlayingTvsState ?? this.nowPlayingTvsState,
        message: message ?? this.message);
  }

  factory TvListStatePlaying.initial() => TvListStatePlaying(
      nowPlayingTvs: [], nowPlayingTvsState: RequestState.Empty, message: '');

  @override
  // TODO: implement props
  List<Object?> get props => [nowPlayingTvs, nowPlayingTvsState, message];
}

class TvListStatePopular extends Equatable {
  final List<Movie> popularTvs;
  final RequestState popularTvsState;

  final String message;

  TvListStatePopular(
      {required this.popularTvs,
      required this.popularTvsState,
      required this.message});

  TvListStatePopular copyWith(
      {List<Movie>? popularTvs,
      RequestState? popularTvsState,
      String? message}) {
    return TvListStatePopular(
        popularTvs: popularTvs ?? this.popularTvs,
        popularTvsState: popularTvsState ?? this.popularTvsState,
        message: message ?? this.message);
  }

  factory TvListStatePopular.initial() => TvListStatePopular(
      popularTvs: [], popularTvsState: RequestState.Empty, message: '');

  @override
  // TODO: implement props
  List<Object?> get props => [popularTvs, popularTvsState, message];
}

class TvListStateTopRated extends Equatable {
  final List<Movie> topRatedTvs;
  final RequestState topRatedTvsState;

  final String message;

  TvListStateTopRated(
      {required this.topRatedTvs,
      required this.topRatedTvsState,
      required this.message});

  TvListStateTopRated copyWith(
      {List<Movie>? topRatedTvs,
      RequestState? topRatedTvsState,
      String? message}) {
    return TvListStateTopRated(
        topRatedTvs: topRatedTvs ?? this.topRatedTvs,
        topRatedTvsState: topRatedTvsState ?? this.topRatedTvsState,
        message: message ?? this.message);
  }

  factory TvListStateTopRated.initial() => TvListStateTopRated(
      topRatedTvs: [], topRatedTvsState: RequestState.Empty, message: '');

  @override
  // TODO: implement props
  List<Object?> get props => [topRatedTvs, topRatedTvsState, message];
}
