import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:detail/detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist
])
void main() {
  late DetailBloc detailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockSaveWatchlist = MockSaveWatchlist();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    detailBloc = DetailBloc(
        getMovieRecommendations: mockGetMovieRecommendations,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
        getWatchListStatus: mockGetWatchListStatus,
        getMovieDetail: mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(detailBloc.state.movieDetailState, RequestState.Empty);
  });

  final tId = 1;
  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  blocTest<DetailBloc, DetailState>(
      'should emit [movieDetailState.Loading,movieDetailState.Loaded,'
      'movieRecommendationState.Loading,movieRecommendationState.Loaded] '
      'when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return detailBloc;
      },
      act: (bloc) => bloc.add(OnGetMovieDetail(tId)),
      expect: () => [
            DetailState.initial()
                .copyWith(movieDetailState: RequestState.Loading),
            DetailState.initial().copyWith(
                movieRecommendationState: RequestState.Loading,
                movieDetail: testMovieDetail,
                movieDetailState: RequestState.Loaded,
                message: ''),
            DetailState.initial().copyWith(
                movieDetail: testMovieDetail,
                movieDetailState: RequestState.Loaded,
                movieRecommendationState: RequestState.Loaded,
                movieRecommendation: tMovieList,
                message: '')
          ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      });

  blocTest<DetailBloc, DetailState>(
      'should emit [movieDetailState.Error] '
      'when movie detail is gotten unsuccessfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('server failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return detailBloc;
      },
      act: (bloc) => bloc.add(OnGetMovieDetail(tId)),
      expect: () => [
            DetailState.initial()
                .copyWith(movieDetailState: RequestState.Loading),
            DetailState.initial().copyWith(
                movieDetailState: RequestState.Error,
                message: 'server failure'),
          ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      });

  blocTest<DetailBloc, DetailState>(
      'should emit [movieDetailState.Loading,movieDetailState.Loaded,'
      'movieRecommendationState.Loading,movieRecommendationState.Error] '
      'when movie recommendation is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('server failure')));
        return detailBloc;
      },
      act: (bloc) => bloc.add(OnGetMovieDetail(tId)),
      expect: () => [
            DetailState.initial()
                .copyWith(movieDetailState: RequestState.Loading),
            DetailState.initial().copyWith(
                movieRecommendationState: RequestState.Loading,
                movieDetail: testMovieDetail,
                movieDetailState: RequestState.Loaded,
                message: ''),
            DetailState.initial().copyWith(
                movieDetail: testMovieDetail,
                movieDetailState: RequestState.Loaded,
                movieRecommendationState: RequestState.Error,
                message: 'server failure')
          ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      });
}
