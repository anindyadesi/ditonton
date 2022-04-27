import 'package:bloc_test/bloc_test.dart';
import 'package:detail/detail.dart';
import 'package:detail/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:core/common/state_enum.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class MockTvDetailEvent extends Fake implements TvDetailEvent {}

class MockTvDetailState extends Fake implements TvDetailState {}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;

  setUpAll(() {
    registerFallbackValue(MockTvDetailBloc());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TvDetailBloc>(create: (context) => mockTvDetailBloc)
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  tearDown(() {
    mockTvDetailBloc.close();
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState(
        tvDetail: MovieDetail.initial(),
        tvDetailState: RequestState.Loading,
        tvRecommendation: [],
        tvRecommendationState: RequestState.Empty,
        isAddedToWatchList: false,
        message: '',
        watchlistMessage: ''));

    final textFinderCircularTvDetail = find.byKey(Key('circular_tvdetail'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(textFinderCircularTvDetail, findsOneWidget);
  });

  testWidgets('Page should display Tv detail when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState(
        tvDetail: MovieDetail.initial(),
        tvDetailState: RequestState.Loaded,
        tvRecommendation: [],
        tvRecommendationState: RequestState.Empty,
        isAddedToWatchList: false,
        message: '',
        watchlistMessage: ''));

    final keyfinderTvTitle = find.byKey(Key('tv_title'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(keyfinderTvTitle, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState(
        tvDetail: MovieDetail.initial(),
        tvDetailState: RequestState.Error,
        tvRecommendation: [],
        tvRecommendationState: RequestState.Empty,
        isAddedToWatchList: false,
        message: 'error message',
        watchlistMessage: ''));

    final textFinderError = find.byKey(Key('error_message_tvdetail'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(textFinderError, findsOneWidget);
  });

  testWidgets('recommendation should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState(
        tvDetail: MovieDetail.initial(),
        tvDetailState: RequestState.Loaded,
        tvRecommendation: [],
        tvRecommendationState: RequestState.Loading,
        isAddedToWatchList: false,
        message: '',
        watchlistMessage: ''));

    final textFinderCircularRecommendation =
        find.byKey(Key('circular_recommendation_tv'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(textFinderCircularRecommendation, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState(
        tvDetail: MovieDetail.initial(),
        tvDetailState: RequestState.Loaded,
        tvRecommendation: [],
        tvRecommendationState: RequestState.Error,
        isAddedToWatchList: false,
        message: '',
        watchlistMessage: 'error message'));

    final textFinderError = find.byKey(Key('recommendation_error_tv'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(textFinderError, findsOneWidget);
  });

  testWidgets('Page should display recommendation Tv when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState(
        tvDetail: MovieDetail.initial(),
        tvDetailState: RequestState.Loaded,
        tvRecommendation: [],
        tvRecommendationState: RequestState.Loaded,
        isAddedToWatchList: false,
        message: '',
        watchlistMessage: ''));

    final keyfinderListRecommendation =
        find.byKey(Key('listview_recommendation_tv'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(keyfinderListRecommendation, findsOneWidget);
  });
}
