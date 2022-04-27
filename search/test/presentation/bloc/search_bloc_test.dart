import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/tv/searchTvs.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/tv/tv_search_bloc.dart';

import 'search_bloc_test.mocks.dart';

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
final tQuery = 'spiderman';

@GenerateMocks([SearchMovies, SearchTvs])
void main() {
  late SearchBloc searchBloc;
  late TvSearchBloc tvSearchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTvs = MockSearchTvs();
    searchBloc = SearchBloc(mockSearchMovies);
    tvSearchBloc = TvSearchBloc(mockSearchTvs);
  });

  ///Movie
  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
      'Should emit [Loading,HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChange(tQuery)),
      wait: Duration(milliseconds: 500),
      expect: () => [SearchLoading(), SearchHasData(tMovieList)],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      });

  blocTest<SearchBloc, SearchState>(
      'Should emit [Loading,Error] when get search is unsuccesfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChange(tQuery)),
      wait: Duration(milliseconds: 500),
      expect: () => [SearchLoading(), SearchError('Server Failure')],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      });

  ///TV

  test('initial state should be empty', () {
    expect(tvSearchBloc.state, TvSearchEmpty());
  });

  blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading,HasData] when data tv is gotten successfully',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChangeTv(tQuery)),
      wait: Duration(milliseconds: 500),
      expect: () => [TvSearchLoading(), TvSearchHasData(tMovieList)],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      });

  blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading,Error] when get search Tv is unsuccesfully',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChangeTv(tQuery)),
      wait: Duration(milliseconds: 500),
      expect: () => [TvSearchLoading(), TvSearchError('Server Failure')],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      });
}
