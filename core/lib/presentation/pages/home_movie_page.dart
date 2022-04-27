import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/movie_list_bloc.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/tv/popular_tvs_page.dart';
import 'package:core/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../../common/utils.dart';
import '../../domain/entities/movie.dart';
import '../../styles/text_styles.dart';
import '../bloc/tv/tv_list_bloc.dart';
import '../bloc/movie_list_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<MovieListBlocPlaying>().add(OnGetNowPlayingMovies());
    context.read<MovieListBlocPopular>().add(OnGetPopularMovies());
    context.read<MovieListBlocTopRated>().add(OnGetTopRatedMovies());
    context.read<TvListBlocPlaying>().add(OnGetNowPlayingTvs());
    context.read<TvListBlocPopular>().add(OnGetPopularTvs());
    context.read<TvListBlocTopRated>().add(OnGetTopRatedTvs());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/circle-g.png'),
                ),
                accountName: Text('Ditonton'),
                accountEmail: Text('ditonton@dicoding.com'),
              ),
              ListTile(
                leading: Icon(Icons.movie_creation_outlined),
                title: Text('Movies'),
                onTap: () {
                  _tabController.animateTo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.tv_outlined),
                title: Text('Tv Series'),
                onTap: () {
                  _tabController.animateTo(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.save_alt),
                title: Text('Watchlist'),
                onTap: () {
                  Navigator.pushNamed(context, WATCHLIST_ROUTE);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, ABOUT_ROUTE);
                },
                leading: Icon(Icons.info_outline),
                title: Text('About'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Ditonton'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_filter_outlined),
                  Text(' Movies'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tv_outlined),
                  Text(' TV Series'),
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                //FirebaseCrashlytics.instance.crash();
                Navigator.pushNamed(context, SEARCH_ROUTE);
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [buildMovies(context), buildTvs(context)],
        ),
      ),
    );
  }

  final Opt optionMovie = Opt.Movie;
  final Opt optionTv = Opt.TvSeries;

  Widget buildMovies(BuildContext context) {
    // final option = Opt.Movie;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          buildBlocNowPlayingMovie(),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          buildBlocPopularMovie(),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          buildBlocTopRated(),
        ],
      ),
    );
  }

  BlocBuilder<MovieListBlocPlaying, MovieListStatePlaying>
      buildBlocNowPlayingMovie() {
    return BlocBuilder<MovieListBlocPlaying, MovieListStatePlaying>(
        builder: (context, state) {
      if (state.nowPlayingMoviesState == RequestState.Loading) {
        return Center(
          key: Key('center_playing'),
          child: CircularProgressIndicator(
            key: Key('circular_playing'),
          ),
        );
      } else if (state.nowPlayingMoviesState == RequestState.Loaded) {
        return MovieList(
            state.nowPlayingMovies, optionMovie, 'movie_list_playing');
      } else if (state.nowPlayingMoviesState == RequestState.Error) {
        return Center(
          key: Key('error_message_movie_playing'),
          child: Text(state.message),
        );
      } else {
        return Text('');
      }
    });
  }

  BlocBuilder<MovieListBlocPopular, MovieListStatePopular>
      buildBlocPopularMovie() {
    return BlocBuilder<MovieListBlocPopular, MovieListStatePopular>(
        builder: (context, state) {
      if (state.popularMoviesState == RequestState.Loading) {
        return Center(
          key: Key('center_popular'),
          child: CircularProgressIndicator(key: Key('circular_popular')),
        );
      } else if (state.popularMoviesState == RequestState.Loaded) {
        return MovieList(
            state.popularMovies, optionMovie, 'movie_list_popular');
      } else if (state.popularMoviesState == RequestState.Error) {
        return Center(
          key: Key('error_message_movie_popular'),
          child: Text(state.message),
        );
      } else {
        return Text('');
      }
    });
  }

  BlocBuilder<MovieListBlocTopRated, MovieListStateTopRated>
      buildBlocTopRated() {
    return BlocBuilder<MovieListBlocTopRated, MovieListStateTopRated>(
        builder: (context, state) {
      if (state.topRatedMoviesState == RequestState.Loading) {
        return Center(
          key: Key('center_toprated'),
          child: CircularProgressIndicator(key: Key('circular_toprated')),
        );
      } else if (state.topRatedMoviesState == RequestState.Loaded) {
        return MovieList(
            state.topRatedMovies, optionMovie, 'movie_list_toprated');
      } else if (state.topRatedMoviesState == RequestState.Error) {
        return Center(
          key: Key('error_message_movie_toprated'),
          child: Text(state.message),
        );
      } else {
        return Text('');
      }
    });
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTvs(BuildContext context) {
    // final option = Opt.TvSeries;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          buildBlocNowPlayingTv(),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
          ),
          buildBlocPopularTv(),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
          ),
          buildBlocTopRatedTv(),
        ],
      ),
    );
  }

  BlocBuilder<TvListBlocPlaying, TvListStatePlaying> buildBlocNowPlayingTv() {
    return BlocBuilder<TvListBlocPlaying, TvListStatePlaying>(
        builder: (context, state) {
      if (state.nowPlayingTvsState == RequestState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.nowPlayingTvsState == RequestState.Loaded) {
        return MovieList(state.nowPlayingTvs, optionTv, 'tv_list_playing');
      } else if (state.nowPlayingTvsState == RequestState.Error) {
        return Center(
          key: Key('error_message'),
          child: Text(state.message),
        );
      } else {
        return Text('');
      }
    });
  }

  BlocBuilder<TvListBlocPopular, TvListStatePopular> buildBlocPopularTv() {
    return BlocBuilder<TvListBlocPopular, TvListStatePopular>(
        builder: (context, state) {
      if (state.popularTvsState == RequestState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.popularTvsState == RequestState.Loaded) {
        return MovieList(state.popularTvs, optionTv, 'tv_list_popular');
      } else if (state.popularTvsState == RequestState.Error) {
        return Center(
          key: Key('error_message'),
          child: Text(state.message),
        );
      } else {
        return Text('Failed');
      }
    });
  }

  BlocBuilder<TvListBlocTopRated, TvListStateTopRated> buildBlocTopRatedTv() {
    return BlocBuilder<TvListBlocTopRated, TvListStateTopRated>(
        builder: (context, state) {
      if (state.topRatedTvsState == RequestState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.topRatedTvsState == RequestState.Loaded) {
        return MovieList(state.topRatedTvs, optionTv, 'tv_list_toprated');
      } else if (state.topRatedTvsState == RequestState.Error) {
        return Center(
          key: Key('error_message'),
          child: Text(state.message),
        );
      } else {
        return Text('Failed');
      }
    });
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final Opt option;
  final String keyList;

  MovieList(this.movies, this.option, this.keyList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        key: Key(keyList),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                debugPrint('movie list on tap: ${movie.id}');
                switch (option) {
                  case (Opt.Movie):
                    Navigator.pushNamed(
                      context,
                      MOVIE_DETAIL_ROUTE,
                      arguments: movie.id,
                    );
                    break;
                  case (Opt.TvSeries):
                    Navigator.pushNamed(
                      context,
                      TV_DETAIL_ROUTE,
                      arguments: movie.id,
                    );
                    break;
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
