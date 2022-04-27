import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:detail/detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  DetailBloc(
      {required this.getMovieDetail,
      required this.getMovieRecommendations,
      required this.getWatchListStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(DetailState.initial()) {
    on<OnGetMovieDetail>((event, emit) async {
      final id = event.id;
      emit(state.copyWith(movieDetailState: RequestState.Loading, message: ''));
      final detailResult = await getMovieDetail.execute(id);
      final recommendationResult = await getMovieRecommendations.execute(id);

      detailResult.fold((failure) async {
        emit(state.copyWith(
            movieDetailState: RequestState.Error, message: failure.message));
      }, (movie) async {
        emit(state.copyWith(
            movieRecommendationState: RequestState.Loading,
            movieDetail: movie,
            movieDetailState: RequestState.Loaded,
            message: ''));
        recommendationResult.fold((failure) {
          emit(state.copyWith(
              movieRecommendationState: RequestState.Error,
              message: failure.message));
        }, (movies) {
          emit(state.copyWith(
              movieRecommendationState: RequestState.Loaded,
              movieRecommendation: movies,
              message: ''));
        });
      });
    });

    on<OnSaveWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie, 0);

      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });

      add(OnGetWatchlistStatus(event.movie.id));
    });

    on<OnRemoveWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie, 0);

      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });

      add(OnGetWatchlistStatus(event.movie.id));
    });

    on<OnGetWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
