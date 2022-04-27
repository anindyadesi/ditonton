part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChangeTv extends TvSearchEvent {
  final String query;

  OnQueryChangeTv(this.query);

  @override
  List<Object> get props => [query];
}
