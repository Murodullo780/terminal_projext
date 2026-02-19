part of 'edit_host_bloc.dart';

@immutable
sealed class EditHostEvent {}

final class InitEditHostEvent extends EditHostEvent {}

final class SaveEditedHost extends EditHostEvent {
  final String host;
  final String port;

  SaveEditedHost({required this.host, required this.port});
}
