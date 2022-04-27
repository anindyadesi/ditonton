import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListBlocPlaying
    extends MockBloc<MovieListEvent, MovieListStatePlaying>
    implements MovieListBlocPlaying {}

class MockMovieListEvent extends Fake implements MovieListEvent {}

class MockMovieListStatePlaying extends Fake implements MovieListStatePlaying {}

class MockMovieListBlocPopular
    extends MockBloc<MovieListEvent, MovieListStatePopular>
    implements MovieListBlocPopular {}

class MockMovieListStatePopular extends Fake implements MovieListStatePopular {}

class MockMovieListBlocTopRated
    extends MockBloc<MovieListEvent, MovieListStateTopRated>
    implements MovieListBlocTopRated {}

class MockMovieListStateTopRated extends Fake
    implements MovieListStateTopRated {}

class MockTvListBlocPlaying extends MockBloc<TvListEvent, TvListStatePlaying>
    implements TvListBlocPlaying {}

class MockTvListEvent extends Fake implements TvListEvent {}

class MockTvListStatePlaying extends Fake implements TvListStatePlaying {}

class MockTvListBlocPopular extends MockBloc<TvListEvent, TvListStatePopular>
    implements TvListBlocPopular {}

class MockTvListStatePopular extends Fake implements TvListStatePopular {}

class MockTvListBlocTopRated extends MockBloc<TvListEvent, TvListStateTopRated>
    implements TvListBlocTopRated {}

class MockTvListStateTopRated extends Fake implements TvListStateTopRated {}

void main() {
  late MockMovieListBlocPlaying movieListBlocPlaying;
  late MockMovieListBlocPopular movieListBlocPopular;
  late MockMovieListBlocTopRated movieListBlocTopRated;
  late MockTvListBlocPlaying tvListBlocPlaying;
  late MockTvListBlocPopular tvListBlocPopular;
  late MockTvListBlocTopRated tvListBlocTopRated;

  setUpAll(() {
    registerFallbackValue(MockMovieListEvent());
    registerFallbackValue(MockMovieListStatePlaying());
    registerFallbackValue(MockMovieListStatePopular());
    registerFallbackValue(MockMovieListStateTopRated());
    registerFallbackValue(MockTvListEvent());
    registerFallbackValue(MockTvListStatePlaying());
    registerFallbackValue(MockTvListStatePopular());
    registerFallbackValue(MockTvListStateTopRated());
  });

  setUp(() {
    movieListBlocPlaying = MockMovieListBlocPlaying();
    movieListBlocPopular = MockMovieListBlocPopular();
    movieListBlocTopRated = MockMovieListBlocTopRated();
    tvListBlocPlaying = MockTvListBlocPlaying();
    tvListBlocPopular = MockTvListBlocPopular();
    tvListBlocTopRated = MockTvListBlocTopRated();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieListBlocPlaying>(
              create: (context) => movieListBlocPlaying),
          BlocProvider<MovieListBlocPopular>(
              create: (context) => movieListBlocPopular),
          BlocProvider<MovieListBlocTopRated>(
              create: (context) => movieListBlocTopRated),
          BlocProvider<TvListBlocPlaying>(
              create: (context) => tvListBlocPlaying),
          BlocProvider<TvListBlocPopular>(
              create: (context) => tvListBlocPopular),
          BlocProvider<TvListBlocTopRated>(
              create: (context) => tvListBlocTopRated),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  tearDown(() {
    movieListBlocPlaying.close();
    movieListBlocPopular.close();
    movieListBlocTopRated.close();
    tvListBlocPlaying.close();
    tvListBlocPopular.close();
    tvListBlocTopRated.close();
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => movieListBlocPlaying.state).thenReturn(MovieListStatePlaying(
        nowPlayingMovies: [],
        nowPlayingMoviesState: RequestState.Loading,
        message: ''));
    when(() => movieListBlocPopular.state).thenReturn(MovieListStatePopular(
        popularMovies: [],
        popularMoviesState: RequestState.Loading,
        message: ''));
    when(() => movieListBlocTopRated.state).thenReturn(MovieListStateTopRated(
        topRatedMovies: [],
        topRatedMoviesState: RequestState.Loading,
        message: ''));

    final singleChildScrollView = find.byType(SingleChildScrollView);
    final textFinderCenterPlaying = find.byKey(Key('center_playing'));
    final textFinderCircularPlaying = find.byKey(Key('circular_playing'));
    final textFinderCenterPopular = find.byKey(Key('center_popular'));
    final textFinderCircularPopular = find.byKey(Key('circular_popular'));
    final textFinderCenterTopRated = find.byKey(Key('center_toprated'));
    final textFinderCircularTopRated = find.byKey(Key('circular_toprated'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(singleChildScrollView, findsOneWidget);
    expect(textFinderCenterPlaying, findsOneWidget);
    expect(textFinderCircularPlaying, findsOneWidget);
    expect(textFinderCenterPopular, findsOneWidget);
    expect(textFinderCircularPopular, findsOneWidget);
    expect(textFinderCenterTopRated, findsOneWidget);
    expect(textFinderCircularTopRated, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => movieListBlocPlaying.state).thenReturn(MovieListStatePlaying(
        nowPlayingMovies: [],
        nowPlayingMoviesState: RequestState.Loaded,
        message: ''));
    when(() => movieListBlocPopular.state).thenReturn(MovieListStatePopular(
        popularMovies: [],
        popularMoviesState: RequestState.Loaded,
        message: ''));
    when(() => movieListBlocTopRated.state).thenReturn(MovieListStateTopRated(
        topRatedMovies: [],
        topRatedMoviesState: RequestState.Loaded,
        message: ''));

    final keyfinderPopular = find.byKey(Key('movie_list_popular'));
    final keyfinderPlaying = find.byKey(Key('movie_list_playing'));
    final keyfinderToprated = find.byKey(Key('movie_list_toprated'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(keyfinderPopular, findsOneWidget);
    expect(keyfinderPlaying, findsOneWidget);
    expect(keyfinderToprated, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => movieListBlocPlaying.state).thenReturn(MovieListStatePlaying(
        nowPlayingMovies: [],
        nowPlayingMoviesState: RequestState.Error,
        message: 'Error message'));
    when(() => movieListBlocPopular.state).thenReturn(MovieListStatePopular(
        popularMovies: [],
        popularMoviesState: RequestState.Error,
        message: 'Error message'));
    when(() => movieListBlocTopRated.state).thenReturn(MovieListStateTopRated(
        topRatedMovies: [],
        topRatedMoviesState: RequestState.Error,
        message: 'Error message'));

    final textFinderPlaying = find.byKey(Key('error_message_movie_playing'));
    final textFinderPopular = find.byKey(Key('error_message_movie_popular'));
    final textFinderToprated = find.byKey(Key('error_message_movie_toprated'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(textFinderPlaying, findsOneWidget);
    expect(textFinderPopular, findsOneWidget);
    expect(textFinderToprated, findsOneWidget);
  });
}
