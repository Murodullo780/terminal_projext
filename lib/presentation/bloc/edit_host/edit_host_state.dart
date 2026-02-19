part of 'edit_host_bloc.dart';

@immutable
sealed class EditHostState {}

final class EditHostInitial extends EditHostState {}

final class EditHostLoaded extends EditHostState {
  final String host;
  final String port;

  EditHostLoaded({required this.host, required this.port});
}

final class EditHostError extends EditHostState {
  final String message;

  EditHostError({required this.message});
}

final class EditHostDone extends EditHostState {}
