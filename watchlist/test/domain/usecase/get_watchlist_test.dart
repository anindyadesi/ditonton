import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecase/get_watchlist_movies.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistMovies(mockMovieRepository);
  });

  final tDataMovies = <List<dynamic>>[];

  test('should get list of watchlist from the repository', () async {
    when(mockMovieRepository.getWatchlistMovies())
        .thenAnswer((_) async => Right(tDataMovies));
    final result = await usecase.execute();
    expect(result, Right(tDataMovies));
  });
}
