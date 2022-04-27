import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/tv/searchTvs.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs _searchTvs;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  TvSearchBloc(this._searchTvs) : super(TvSearchEmpty()) {
    on<OnQueryChangeTv>((event, emit) async {
      final query = event.query;

      emit(TvSearchLoading());

      final result = await _searchTvs.execute(query);

      result.fold((failure) {
        emit(TvSearchError(failure.message));
      }, (data) {
        emit(TvSearchHasData(data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
