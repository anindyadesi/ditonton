import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:detail/detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvDetailBloc(
      {required this.getWatchListStatus,
      required this.getTvDetail,
      required this.getTvRecommendations,
      required this.removeWatchlist,
      required this.saveWatchlist})
      : super(TvDetailState.initial()) {
    on<OnGetTvDetail>((event, emit) async {
      final id = event.id;
      emit(state.copyWith(tvDetailState: RequestState.Loading, message: ''));

      final tvDetailResult = await getTvDetail.execute(id);
      final tvRecommendationResult = await getTvRecommendations.execute(id);

      tvDetailResult.fold((failure) async {
        emit(state.copyWith(
            tvDetailState: RequestState.Error, message: failure.message));
      }, (tv) async {
        emit(state.copyWith(
            tvRecommendationState: RequestState.Loading,
            tvDetail: tv,
            tvDetailState: RequestState.Loaded,
            message: ''));
        tvRecommendationResult.fold((failure) {
          emit(state.copyWith(
              tvRecommendationState: RequestState.Error,
              message: failure.message));
        }, (tvs) {
          emit(state.copyWith(
              tvRecommendationState: RequestState.Loaded,
              tvRecommendation: tvs,
              message: ''));
        });
      });
    });

    on<OnTvSaveWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie, 1);
      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });
      add(OnGetTvWatchlistStatus(event.movie.id));
    });

    on<OnTvRemoveWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie, 1);
      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });
      add(OnGetTvWatchlistStatus(event.movie.id));
    });

    on<OnGetTvWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchList: result));
    });
  }
}
