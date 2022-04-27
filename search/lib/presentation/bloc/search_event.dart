part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChange extends SearchEvent {
  final String query;

  OnQueryChange(this.query);

  @override
  List<Object> get props => [query];
}
