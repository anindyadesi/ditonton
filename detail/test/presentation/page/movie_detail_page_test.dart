import 'package:bloc_test/bloc_test.dart';
import 'package:detail/detail.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:core/common/state_enum.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';

class MockMovieDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements DetailBloc {}

class MockMovieDetailEvent extends Fake implements DetailEvent {}

class MockMovieDetailState extends Fake implements DetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(MockMovieDetailBloc());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DetailBloc>(create: (context) => mockMovieDetailBloc)
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  tearDown(() {
    mockMovieDetailBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(DetailState(
        movieDetail: MovieDetail.initial(),
        movieDetailState: RequestState.Loading,
        movieRecommendation: [],
        movieRecommendationState: RequestState.Empty,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: ''));

    final textFinderCircularMovieDetail =
        find.byKey(Key('circular_moviedetail'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(textFinderCircularMovieDetail, findsOneWidget);
  });

  testWidgets('Page should display movie detail when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(DetailState(
        movieDetail: MovieDetail.initial(),
        movieDetailState: RequestState.Loaded,
        movieRecommendation: [],
        movieRecommendationState: RequestState.Empty,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: ''));

    final keyfinderMovieTitle = find.byKey(Key('movie_title'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(keyfinderMovieTitle, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(DetailState(
        movieDetail: MovieDetail.initial(),
        movieDetailState: RequestState.Error,
        movieRecommendation: [],
        movieRecommendationState: RequestState.Empty,
        isAddedToWatchlist: false,
        message: 'error message',
        watchlistMessage: ''));

    final textFinderError = find.byKey(Key('error_message_moviedetail'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(textFinderError, findsOneWidget);
  });

  testWidgets('recommendation should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(DetailState(
        movieDetail: MovieDetail.initial(),
        movieDetailState: RequestState.Loaded,
        movieRecommendation: [],
        movieRecommendationState: RequestState.Loading,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: ''));

    final textFinderCircularRecommendation =
        find.byKey(Key('circular_recommendation'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(textFinderCircularRecommendation, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(DetailState(
        movieDetail: MovieDetail.initial(),
        movieDetailState: RequestState.Loaded,
        movieRecommendation: [],
        movieRecommendationState: RequestState.Error,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: 'error message'));

    final textFinderError = find.byKey(Key('recommendation_error'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(textFinderError, findsOneWidget);
  });

  testWidgets('Page should display recommendation movie when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(DetailState(
        movieDetail: MovieDetail.initial(),
        movieDetailState: RequestState.Loaded,
        movieRecommendation: [],
        movieRecommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: ''));

    final keyfinderListRecommendation =
        find.byKey(Key('listview_recommendation'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(keyfinderListRecommendation, findsOneWidget);
  });
}
