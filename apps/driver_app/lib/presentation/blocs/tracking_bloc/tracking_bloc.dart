import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:geolocator/geolocator.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  WebSocketChannel? _channel;
  StreamSubscription<Position>? _positionStream;
  String? _driverId;

  TrackingBloc() : super(TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    _driverId = event.driverId;
    _channel = WebSocketChannel.connect(Uri.parse(event.wsUrl));

    // Request permission
    await Geolocator.requestPermission();

    // Start listening to location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      final locationData = jsonEncode({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "driverId": _driverId,
      });

      print("📡 Sending Location: $locationData");
      _channel?.sink.add(locationData);
    });

    emit(TrackingInProgress());
  }

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _positionStream?.cancel();
    _channel?.sink.close();
    emit(TrackingStopped());
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
