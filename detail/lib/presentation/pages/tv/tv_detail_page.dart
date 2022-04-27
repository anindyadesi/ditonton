import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../bloc/tv/tv_detail_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detailTv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvDetailBloc>().add(OnGetTvDetail(widget.id));
    context.read<TvDetailBloc>().add(OnGetTvWatchlistStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBloc(),
    );
  }

  BlocBuilder<TvDetailBloc, TvDetailState> buildBloc() {
    return BlocBuilder<TvDetailBloc, TvDetailState>(
      builder: (context, state) {
        if (state.tvDetailState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(key: Key('circular_tvdetail')),
          );
        } else if (state.tvDetailState == RequestState.Loaded) {
          final tv = state.tvDetail;
          return SafeArea(
            child: DetailContentTv(
                tv, state.tvRecommendation, state.isAddedToWatchList),
          );
        } else if (state.tvDetailState == RequestState.Error) {
          return Center(
            key: Key('error_message_tvdetail'),
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class DetailContentTv extends StatelessWidget {
  final MovieDetail tv;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  DetailContentTv(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tv.title,
                                style: kHeading5, key: Key('tv_title')),
                            BlocListener<TvDetailBloc, TvDetailState>(
                              listenWhen: (oldState, newState) =>
                                  oldState.watchlistMessage !=
                                      newState.watchlistMessage &&
                                  newState.watchlistMessage != '',
                              listener: (context, state) {
                                if (state.watchlistMessage ==
                                        TvDetailBloc
                                            .watchlistAddSuccessMessage ||
                                    state.watchlistMessage ==
                                        TvDetailBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.watchlistMessage),
                                    ),
                                  );
                                }
                              },
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    context
                                        .read<TvDetailBloc>()
                                        .add(OnTvSaveWatchlist(tv, 0));
                                  } else {
                                    context
                                        .read<TvDetailBloc>()
                                        .add(OnTvRemoveWatchlist(tv, 0));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              _showDuration(tv.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            buildBlocBuilderTvRecommendation(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  BlocBuilder<TvDetailBloc, TvDetailState> buildBlocBuilderTvRecommendation() {
    return BlocBuilder<TvDetailBloc, TvDetailState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.tvRecommendationState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(
                  key: Key('circular_recommendation_tv')),
            );
          } else if (state.tvRecommendationState == RequestState.Error) {
            return Text(state.message, key: Key('recommendation_error_tv'));
          } else if (state.tvRecommendationState == RequestState.Loaded) {
            return Container(
              height: 150,
              child: ListView.builder(
                key: Key('listview_recommendation_tv'),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = recommendations[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          TvDetailPage.ROUTE_NAME,
                          arguments: movie.id,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: recommendations.length,
              ),
            );
          } else {
            return Container();
          }
        });
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
