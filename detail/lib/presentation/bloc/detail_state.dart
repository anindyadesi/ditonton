part of 'detail_bloc.dart';

class DetailState extends Equatable {
  final MovieDetail movieDetail;
  final RequestState movieDetailState;
  final List<Movie> movieRecommendation;
  final RequestState movieRecommendationState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  DetailState(
      {required this.movieDetail,
      required this.movieDetailState,
      required this.movieRecommendation,
      required this.movieRecommendationState,
      required this.isAddedToWatchlist,
      required this.message,
      required this.watchlistMessage});

  DetailState copyWith({
    MovieDetail? movieDetail,
    RequestState? movieDetailState,
    List<Movie>? movieRecommendation,
    RequestState? movieRecommendationState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return DetailState(
        movieDetail: movieDetail ?? this.movieDetail,
        movieDetailState: movieDetailState ?? this.movieDetailState,
        movieRecommendation: movieRecommendation ?? this.movieRecommendation,
        movieRecommendationState:
            movieRecommendationState ?? this.movieRecommendationState,
        isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
        message: message ?? this.message,
        watchlistMessage: watchlistMessage ?? this.watchlistMessage);
  }

  factory DetailState.initial() => DetailState(
      movieDetail: MovieDetail.initial(),
      movieDetailState: RequestState.Empty,
      movieRecommendation: [],
      movieRecommendationState: RequestState.Empty,
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '');

  @override
  List<Object> get props => [
        movieDetail,
        movieDetailState,
        movieRecommendation,
        movieRecommendationState,
        isAddedToWatchlist,
        message,
        watchlistMessage
      ];
}
