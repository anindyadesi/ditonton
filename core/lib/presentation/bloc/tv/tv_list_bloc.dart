import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/tv/get_now_playing_tvs.dart';
import '../../../domain/usecases/tv/get_popular_tvs.dart';
import '../../../domain/usecases/tv/get_top_rated_tvs.dart';

part 'tv_list_state.dart';
part 'tv_list_event.dart';

class TvListBlocPlaying extends Bloc<TvListEvent, TvListStatePlaying> {
  final GetNowPlayingTvs getNowPlayingTvs;

  TvListBlocPlaying({
    required this.getNowPlayingTvs,
  }) : super(TvListStatePlaying.initial()) {
    on<OnGetNowPlayingTvs>((event, emit) async {
      emit(state.copyWith(
          nowPlayingTvsState: RequestState.Loading, message: ''));
      final nowPlayingResult = await getNowPlayingTvs.execute();

      nowPlayingResult.fold((failure) async {
        emit(state.copyWith(
            nowPlayingTvsState: RequestState.Error, message: failure.message));
      }, (tvs) async {
        emit(state.copyWith(
            nowPlayingTvsState: RequestState.Loaded, nowPlayingTvs: tvs));
      });
    });
  }
}

class TvListBlocPopular extends Bloc<TvListEvent, TvListStatePopular> {
  final GetPopularTvs getPopularTvs;

  TvListBlocPopular({
    required this.getPopularTvs,
  }) : super(TvListStatePopular.initial()) {
    on<OnGetPopularTvs>((event, emit) async {
      emit(state.copyWith(popularTvsState: RequestState.Loading, message: ''));
      final popularResult = await getPopularTvs.execute();

      popularResult.fold((failure) async {
        emit(state.copyWith(
            popularTvsState: RequestState.Error, message: failure.message));
      }, (tvs) async {
        emit(state.copyWith(
            popularTvsState: RequestState.Loaded, popularTvs: tvs));
      });
    });
  }
}

class TvListBlocTopRated extends Bloc<TvListEvent, TvListStateTopRated> {
  final GetTopRatedTvs getTopRatedTvs;

  TvListBlocTopRated({
    required this.getTopRatedTvs,
  }) : super(TvListStateTopRated.initial()) {
    on<OnGetTopRatedTvs>((event, emit) async {
      emit(state.copyWith(topRatedTvsState: RequestState.Loading, message: ''));
      final topRatedResult = await getTopRatedTvs.execute();

      topRatedResult.fold((failure) async {
        emit(state.copyWith(
            topRatedTvsState: RequestState.Error, message: failure.message));
      }, (tvs) async {
        emit(state.copyWith(
            topRatedTvsState: RequestState.Loaded, topRatedTvs: tvs));
      });
    });
  }
}
