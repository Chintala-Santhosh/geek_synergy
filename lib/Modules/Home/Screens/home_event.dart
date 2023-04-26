
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../Models/movies_list_request.dart';


@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}



class MoviesList extends HomeEvent {
  final MoviesListRequest request;
  const MoviesList({required this.request});
  @override
  List<Object?> get props => [request];

}