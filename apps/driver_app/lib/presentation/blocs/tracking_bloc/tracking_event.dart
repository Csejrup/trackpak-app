part of 'tracking_bloc.dart';

abstract class TrackingEvent {}

class StartTracking extends TrackingEvent {
  final String driverId;
  final String wsUrl;
  final String accessToken;
  StartTracking({
    required this.driverId,
    required this.wsUrl,
    required this.accessToken,
  });
}

class StopTracking extends TrackingEvent {}

class ErrorTracking extends TrackingEvent {}
