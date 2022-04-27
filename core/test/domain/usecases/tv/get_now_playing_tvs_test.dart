import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvs usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingTvs(mockMovieRepository);
  });

  final tTvs = <Movie>[];

  test('should get list of Tv Repositories from the repository', () async {
    // arrange
    when(mockMovieRepository.getNowPlayingTv())
        .thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvs));
  });
}
