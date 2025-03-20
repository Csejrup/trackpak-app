import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;

  TrackingBloc() : super(TrackingInitial()) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      emit(TrackingInProgress());
      _channel = WebSocketChannel.connect(Uri.parse(event.wsUrl));

      _wsSubscription = _channel!.stream.listen((message) {
        final data = jsonDecode(message);
        emit(
          TrackingUpdate(
            driverId: data['driverId'],
            latitude: data['latitude'],
            longitude: data['longitude'],
            timestamp: DateTime.parse(data['timestamp']),
          ),
        );
      });
    } catch (e) {
      emit(TrackingError("Failed to connect to tracking: $e"));
    }
  }

  Future<void> _onStopListening(
    StopListening event,
    Emitter<TrackingState> emit,
  ) async {
    await _wsSubscription?.cancel();
    await _channel?.sink.close();
    emit(TrackingStopped());
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
