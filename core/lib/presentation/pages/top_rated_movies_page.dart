import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../bloc/movie_list_bloc.dart';
import '../widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieListBlocTopRated>().add(OnGetTopRatedMovies());
  }

  final option = Opt.Movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildBloc(),
      ),
    );
  }

  BlocBuilder<MovieListBlocTopRated, MovieListStateTopRated> buildBloc() {
    return BlocBuilder<MovieListBlocTopRated, MovieListStateTopRated>(
      builder: (context, state) {
        if (state.topRatedMoviesState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.topRatedMoviesState == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.topRatedMovies[index];
              return MovieCard(movie, option);
            },
            itemCount: state.topRatedMovies.length,
          );
        } else {
          return Center(
            key: Key('error_message'),
            child: Text(state.message),
          );
        }
      },
    );
  }
}
