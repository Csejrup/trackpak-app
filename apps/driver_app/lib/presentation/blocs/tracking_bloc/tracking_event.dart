part of 'tracking_bloc.dart';

abstract class TrackingEvent {}

class StartTracking extends TrackingEvent {
  final String driverId;
  final String wsUrl;
  StartTracking({required this.driverId, required this.wsUrl});
}

class StopTracking extends TrackingEvent {}
