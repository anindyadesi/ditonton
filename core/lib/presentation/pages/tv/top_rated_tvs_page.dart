import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
import '../../bloc/tv/tv_list_bloc.dart';
import '../../widgets/movie_card_list.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tvs';

  @override
  _TopRatedTvsPageState createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvListBlocTopRated>().add(OnGetTopRatedTvs());
  }

  final option = Opt.TvSeries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildBlocTopRatedTv(),
      ),
    );
  }

  BlocBuilder<TvListBlocTopRated, TvListStateTopRated> buildBlocTopRatedTv() {
    return BlocBuilder<TvListBlocTopRated, TvListStateTopRated>(
      builder: (context, state) {
        if (state.topRatedTvsState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.topRatedTvsState == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tvs = state.topRatedTvs[index];
              return MovieCard(tvs, option);
            },
            itemCount: state.topRatedTvs.length,
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
