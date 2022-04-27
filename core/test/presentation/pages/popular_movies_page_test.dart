import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListBlocPopular
    extends MockBloc<MovieListEvent, MovieListStatePopular>
    implements MovieListBlocPopular {}

class MockMovieListEvent extends Fake implements MovieListEvent {}

class MockMovieListStatePopular extends Fake implements MovieListStatePopular {}

void main() {
  late MockMovieListBlocPopular mockMovieListBlocPopular;

  setUpAll(() {
    registerFallbackValue(MockMovieListEvent());
    registerFallbackValue(MockMovieListStatePopular());
  });

  setUp(() {
    mockMovieListBlocPopular = MockMovieListBlocPopular();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBlocPopular>(
              create: (context) => mockMovieListBlocPopular),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  tearDown(() {
    mockMovieListBlocPopular.close();
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieListBlocPopular.state).thenReturn(MovieListStatePopular(
        popularMovies: [],
        popularMoviesState: RequestState.Loading,
        message: ''));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieListBlocPopular.state).thenReturn(MovieListStatePopular(
        popularMovies: [],
        popularMoviesState: RequestState.Loaded,
        message: ''));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockMovieListBlocPopular.state).thenReturn(MovieListStatePopular(
        popularMovies: [],
        popularMoviesState: RequestState.Error,
        message: 'Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
