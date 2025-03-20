part of 'tracking_bloc.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {}

class TrackingStopped extends TrackingState {}

class TrackingError extends TrackingState {
  final String message;

  TrackingError(this.message);
}
