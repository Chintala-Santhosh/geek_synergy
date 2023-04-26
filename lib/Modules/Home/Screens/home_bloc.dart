import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Utils/base_state.dart';
import '../Models/movies_list_response.dart';
import 'home_event.dart';
import 'home_repository.dart';

class HomeBloc extends Bloc<HomeEvent,BaseState> {
  final HomeRepository _repository = HomeRepository();


  Init get initialState => Init();

  HomeBloc({required BaseState initialState}) :super(initialState) {
    on <MoviesList>(_onMoviesList);
  }
  Future<void> _onMoviesList(event, Emitter<BaseState>emit) async {
    emit(Loading());
    if (kDebugMode) {
      print("Movies List details");
    }
    try {
      MoviesListResponse response = await _repository.moviesList(event.request);
      emit(DataLoaded(data: response, event: 'MoviesList'));
    } catch (e) {
      emit(BaseError(e.toString()));
    }
  }

}

