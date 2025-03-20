part of 'tracking_bloc.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {}

class TrackingUpdate extends TrackingState {
  final String driverId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  TrackingUpdate({
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class TrackingStopped extends TrackingState {}

class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}
