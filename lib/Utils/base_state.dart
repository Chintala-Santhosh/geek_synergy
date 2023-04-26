import 'package:equatable/equatable.dart';
class BaseState extends Equatable {
  const BaseState();
  @override
  String toString() => 'BaseState';
  @override
  List<Object> get props => [];

}

class Init extends BaseState {
  @override
  String toString() => 'Init';
}

class Loading extends BaseState {
  @override
  String toString() => 'Loading';

}

class DataLoaded<T> extends BaseState {
  final T data;
  final String event;

  const DataLoaded({required this.data, required this.event});

  @override
  String toString() => 'DataLoaded';

}
class BaseError extends BaseState {
  final String errorMessage;

  BaseError(this.errorMessage);

  @override
  String toString() => 'Error';

}