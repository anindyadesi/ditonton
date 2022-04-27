import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../bloc/movie_list_bloc.dart';
import '../widgets/movie_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';
  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieListBlocPopular>().add(OnGetPopularMovies());
  }

  final option = Opt.Movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildBloc(),
      ),
    );
  }

  BlocBuilder<MovieListBlocPopular, MovieListStatePopular> buildBloc() {
    return BlocBuilder<MovieListBlocPopular, MovieListStatePopular>(
      builder: (context, state) {
        if (state.popularMoviesState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.popularMoviesState == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.popularMovies[index];
              return MovieCard(movie, option);
            },
            itemCount: state.popularMovies.length,
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
