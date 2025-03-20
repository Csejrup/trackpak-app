import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  WebSocketChannel? _channel;
  StreamSubscription<Position>? _positionSubscription;

  TrackingBloc() : super(TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      // 🔗 Connect to your backend websocket
      _channel = WebSocketChannel.connect(Uri.parse(event.wsUrl));
      emit(TrackingInProgress());

      // 🛰 Start GPS stream
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50,
        ),
      ).listen((Position position) {
        final trackingData = {
          'driverId': event.driverId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // 🚀 Send location to backend
        _channel?.sink.add(jsonEncode(trackingData));
      });
    } catch (e) {
      emit(TrackingError("Failed to start tracking: $e"));
    }
  }

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _positionSubscription?.cancel();
    await _channel?.sink.close();
    emit(TrackingStopped());
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
