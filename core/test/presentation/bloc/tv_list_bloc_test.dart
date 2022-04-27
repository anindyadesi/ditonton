import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:core/domain/usecases/tv/get_popular_tvs.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:core/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs, GetNowPlayingTvs, GetPopularTvs])
void main() {
  late TvListBlocPlaying tvListBlocPlaying;
  late TvListBlocTopRated tvListBlocTopRated;
  late TvListBlocPopular tvListBlocPopular;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late int listenerCallCount;
  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    tvListBlocPlaying =
        TvListBlocPlaying(getNowPlayingTvs: mockGetNowPlayingTvs);
    tvListBlocPopular = TvListBlocPopular(getPopularTvs: mockGetPopularTvs);
    tvListBlocTopRated = TvListBlocTopRated(getTopRatedTvs: mockGetTopRatedTvs);
  });
  final tTv = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Movie>[tTv];

  //Tvs

  test('initial state now playing should be empty', () {
    expect(tvListBlocPlaying.state.nowPlayingTvsState, RequestState.Empty);
  });

  blocTest<TvListBlocPlaying, TvListStatePlaying>(
      'should emit [tvliststate.Loading,tvliststate.Loaded,'
      'when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBlocPlaying;
      },
      act: (bloc) => bloc.add(OnGetNowPlayingTvs()),
      expect: () => [
            TvListStatePlaying.initial()
                .copyWith(nowPlayingTvsState: RequestState.Loading),
            TvListStatePlaying.initial().copyWith(
                nowPlayingTvs: tTvList,
                nowPlayingTvsState: RequestState.Loaded,
                message: ''),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
      });

  blocTest<TvListBlocPlaying, TvListStatePlaying>(
      'Should emit [Loading,Error] when get now playing tv is unsuccessfully',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBlocPlaying;
      },
      act: (bloc) => bloc.add(OnGetNowPlayingTvs()),
      expect: () => [
            TvListStatePlaying.initial()
                .copyWith(nowPlayingTvsState: RequestState.Loading),
            TvListStatePlaying.initial().copyWith(
                nowPlayingTvsState: RequestState.Error,
                message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
      });

  test('initial state popular should be empty', () {
    expect(tvListBlocPopular.state.popularTvsState, RequestState.Empty);
  });
  blocTest<TvListBlocPopular, TvListStatePopular>(
      'should emit [popularTvsState.Loading,popularTvsState.Loaded,'
      'when data is gotten successfully',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBlocPopular;
      },
      act: (bloc) => bloc.add(OnGetPopularTvs()),
      expect: () => [
            TvListStatePopular.initial()
                .copyWith(popularTvsState: RequestState.Loading),
            TvListStatePopular.initial().copyWith(
                popularTvs: tTvList,
                popularTvsState: RequestState.Loaded,
                message: ''),
          ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
      });

  blocTest<TvListBlocPopular, TvListStatePopular>(
      'Should emit [Loading,Error] when get now popular tv is unsuccessfully',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBlocPopular;
      },
      act: (bloc) => bloc.add(OnGetPopularTvs()),
      expect: () => [
            TvListStatePopular.initial()
                .copyWith(popularTvsState: RequestState.Loading),
            TvListStatePopular.initial().copyWith(
                popularTvsState: RequestState.Error, message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
      });

  test('initial state Top Rated should be empty', () {
    expect(tvListBlocTopRated.state.topRatedTvsState, RequestState.Empty);
  });
  blocTest<TvListBlocTopRated, TvListStateTopRated>(
      'should emit [topRatedTvsState.Loading,topRatedTvsState.Loaded,'
      'when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBlocTopRated;
      },
      act: (bloc) => bloc.add(OnGetTopRatedTvs()),
      expect: () => [
            TvListStateTopRated.initial()
                .copyWith(topRatedTvsState: RequestState.Loading),
            TvListStateTopRated.initial().copyWith(
                topRatedTvs: tTvList,
                topRatedTvsState: RequestState.Loaded,
                message: ''),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      });

  blocTest<TvListBlocTopRated, TvListStateTopRated>(
      'Should emit [Loading,Error] when get top rated tv is unsuccessfully',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBlocTopRated;
      },
      act: (bloc) => bloc.add(OnGetTopRatedTvs()),
      expect: () => [
            TvListStateTopRated.initial()
                .copyWith(topRatedTvsState: RequestState.Loading),
            TvListStateTopRated.initial().copyWith(
                topRatedTvsState: RequestState.Error,
                message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      });
}
