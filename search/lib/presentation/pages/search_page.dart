import 'package:core/common/state_enum.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/search_bloc.dart';
import '../bloc/tv/tv_search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final optionTvs = Opt.TvSeries;
  final optionMovie = Opt.Movie;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc>().add(OnQueryChange(query));
                context.read<TvSearchBloc>().add(OnQueryChangeTv(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            TabBar(controller: _tabController, tabs: [
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
            ]),
            Expanded(
              child: TabBarView(
                  key: Key('ini_tabbar'),
                  controller: _tabController,
                  children: [searchMoviesBloc(), searchTvsBloc()]),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<SearchBloc, SearchState> searchMoviesBloc() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchHasData) {
          final result = state.result;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final movie = result[index];
              return MovieCard(movie, optionMovie);
            },
            itemCount: result.length,
          );
        } else if (state is SearchError) {
          return Center(
            key: Key('error_message'),
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }

  BlocBuilder<TvSearchBloc, TvSearchState> searchTvsBloc() {
    return BlocBuilder<TvSearchBloc, TvSearchState>(
      builder: (context, state) {
        if (state is TvSearchLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvSearchHasData) {
          final result = state.result;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final movie = result[index];
              return MovieCard(movie, optionTvs);
            },
            itemCount: result.length,
          );
        } else if (state is TvSearchError) {
          return Center(
            key: Key('error_message'),
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
