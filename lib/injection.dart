import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:core/domain/usecases/tv/get_popular_tvs.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:detail/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:search/search.dart';
import 'package:watchlist/watchlist.dart';
import 'package:detail/detail.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => TvSearchBloc(locator()),
  );
  locator.registerFactory(
    () => SearchBloc(locator()),
  );
  locator.registerFactory(
    () => WatchlistBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => DetailBloc(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        removeWatchlist: locator(),
        saveWatchlist: locator()),
  );
  locator.registerFactory(
    () => TvDetailBloc(
        getTvDetail: locator(),
        getTvRecommendations: locator(),
        getWatchListStatus: locator(),
        removeWatchlist: locator(),
        saveWatchlist: locator()),
  );

  locator.registerFactory(
    () => MovieListBlocPlaying(getNowPlayingMovies: locator()),
  );
  locator.registerFactory(
    () => MovieListBlocPopular(getPopularMovies: locator()),
  );
  locator.registerFactory(
    () => MovieListBlocTopRated(getTopRatedMovies: locator()),
  );

  locator.registerFactory(
    () => TvListBlocPlaying(getNowPlayingTvs: locator()),
  );
  locator.registerFactory(
    () => TvListBlocPopular(getPopularTvs: locator()),
  );
  locator.registerFactory(
    () => TvListBlocTopRated(getTopRatedTvs: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  //locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton(() => HttpSSLPining.client);
}
