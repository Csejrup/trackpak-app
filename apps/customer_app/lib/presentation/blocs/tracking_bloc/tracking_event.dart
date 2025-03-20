part of 'tracking_bloc.dart';

abstract class TrackingEvent {}

class StartListening extends TrackingEvent {
  final String wsUrl;
  StartListening({required this.wsUrl});
}

class StopListening extends TrackingEvent {}
