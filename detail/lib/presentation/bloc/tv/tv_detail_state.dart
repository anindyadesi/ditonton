part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final MovieDetail tvDetail;
  final RequestState tvDetailState;
  final List<Movie> tvRecommendation;
  final RequestState tvRecommendationState;
  final bool isAddedToWatchList;
  final String message;
  final String watchlistMessage;

  TvDetailState(
      {required this.tvDetail,
      required this.tvDetailState,
      required this.tvRecommendation,
      required this.tvRecommendationState,
      required this.isAddedToWatchList,
      required this.message,
      required this.watchlistMessage});

  TvDetailState copyWith(
      {MovieDetail? tvDetail,
      RequestState? tvDetailState,
      List<Movie>? tvRecommendation,
      RequestState? tvRecommendationState,
      bool? isAddedToWatchList,
      String? message,
      String? watchlistMessage}) {
    return TvDetailState(
        tvDetail: tvDetail ?? this.tvDetail,
        tvDetailState: tvDetailState ?? this.tvDetailState,
        tvRecommendation: tvRecommendation ?? this.tvRecommendation,
        tvRecommendationState:
            tvRecommendationState ?? this.tvRecommendationState,
        isAddedToWatchList: isAddedToWatchList ?? this.isAddedToWatchList,
        message: message ?? this.message,
        watchlistMessage: watchlistMessage ?? this.watchlistMessage);
  }

  factory TvDetailState.initial() => TvDetailState(
      tvDetail: MovieDetail.initial(),
      tvDetailState: RequestState.Empty,
      tvRecommendation: [],
      tvRecommendationState: RequestState.Empty,
      isAddedToWatchList: false,
      message: '',
      watchlistMessage: '');

  @override
  List<Object> get props => [
        tvDetail,
        tvDetailState,
        tvRecommendation,
        tvRecommendationState,
        isAddedToWatchList,
        message,
        watchlistMessage
      ];
}
