import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:core/presentation/pages/tv/popular_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvListBlocPopular extends MockBloc<TvListEvent, TvListStatePopular>
    implements TvListBlocPopular {}

class MockTvListEvent extends Fake implements TvListEvent {}

class MockTvListStatePopular extends Fake implements TvListStatePopular {}

void main() {
  late MockTvListBlocPopular mockTvListBlocPopular;

  setUpAll(() {
    registerFallbackValue(MockTvListEvent());
    registerFallbackValue(MockTvListStatePopular());
  });

  setUp(() {
    mockTvListBlocPopular = MockTvListBlocPopular();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TvListBlocPopular>(
              create: (context) => mockTvListBlocPopular),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  tearDown(() {
    mockTvListBlocPopular.close();
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvListBlocPopular.state).thenReturn(TvListStatePopular(
        popularTvs: [], popularTvsState: RequestState.Loading, message: ''));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvListBlocPopular.state).thenReturn(TvListStatePopular(
        popularTvs: [], popularTvsState: RequestState.Loaded, message: ''));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTvListBlocPopular.state).thenReturn(TvListStatePopular(
        popularTvs: [],
        popularTvsState: RequestState.Error,
        message: 'Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
