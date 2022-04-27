import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListBlocTopRated
    extends MockBloc<MovieListEvent, MovieListStateTopRated>
    implements MovieListBlocTopRated {}

class MockMovieListEvent extends Fake implements MovieListEvent {}

class MockMovieListStateTopRated extends Fake
    implements MovieListStateTopRated {}

void main() {
  late MockMovieListBlocTopRated mockMovieListBlocTopRated;

  setUpAll(() {
    registerFallbackValue(MockMovieListEvent());
    registerFallbackValue(MockMovieListStateTopRated());
  });

  setUp(() {
    mockMovieListBlocTopRated = MockMovieListBlocTopRated();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieListBlocTopRated>(
          create: (context) => mockMovieListBlocTopRated,
        )
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    mockMovieListBlocTopRated.close();
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieListBlocTopRated.state).thenReturn(
        MovieListStateTopRated(
            topRatedMovies: [],
            topRatedMoviesState: RequestState.Loading,
            message: ''));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieListBlocTopRated.state).thenReturn(
        MovieListStateTopRated(
            topRatedMovies: [],
            topRatedMoviesState: RequestState.Loaded,
            message: ''));
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockMovieListBlocTopRated.state).thenReturn(
        MovieListStateTopRated(
            topRatedMovies: [],
            topRatedMoviesState: RequestState.Error,
            message: ''));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
