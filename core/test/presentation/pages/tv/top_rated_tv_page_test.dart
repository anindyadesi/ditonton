import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvListBlocTopRated extends MockBloc<TvListEvent, TvListStateTopRated>
    implements TvListBlocTopRated {}

class MockTvListEvent extends Fake implements TvListEvent {}

class MockTvListStateTopRated extends Fake implements TvListStateTopRated {}

void main() {
  late MockTvListBlocTopRated mockTvListBlocTopRated;

  setUpAll(() {
    registerFallbackValue(MockTvListEvent());
    registerFallbackValue(MockTvListStateTopRated());
  });

  setUp(() {
    mockTvListBlocTopRated = MockTvListBlocTopRated();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvListBlocTopRated>(
          create: (context) => mockTvListBlocTopRated,
        )
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    mockTvListBlocTopRated.close();
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvListBlocTopRated.state).thenReturn(TvListStateTopRated(
        topRatedTvs: [], topRatedTvsState: RequestState.Loading, message: ''));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvListBlocTopRated.state).thenReturn(TvListStateTopRated(
        topRatedTvs: [], topRatedTvsState: RequestState.Loaded, message: ''));
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTvListBlocTopRated.state).thenReturn(TvListStateTopRated(
        topRatedTvs: [], topRatedTvsState: RequestState.Error, message: ''));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
