import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
import '../../bloc/tv/tv_list_bloc.dart';
import '../../widgets/movie_card_list.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tvs';

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvListBlocPopular>().add(OnGetPopularTvs());
  }

  final option = Opt.TvSeries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Popular Tv Serial'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0), child: buildBlocPopularTv()));
  }

  BlocBuilder<TvListBlocPopular, TvListStatePopular> buildBlocPopularTv() {
    return BlocBuilder<TvListBlocPopular, TvListStatePopular>(
        builder: (context, state) {
      if (state.popularTvsState == RequestState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.popularTvsState == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final movie = state.popularTvs[index];
            return MovieCard(movie, option);
          },
          itemCount: state.popularTvs.length,
        );
      } else {
        return Center(
          key: Key('error_message'),
          child: Text(state.message),
        );
      }
    });
  }
}
