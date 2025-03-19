part of 'tracking_bloc.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {}

class TrackingStopped extends TrackingState {}
