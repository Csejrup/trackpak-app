import 'package:customer_app/presentation/blocs/tracking_bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackingDetails extends StatefulWidget {
  const TrackingDetails({
    super.key,
    required this.orderId,
    required this.positionInQueue,
    required this.totalOrders,
  });

  final String orderId;
  final int positionInQueue; // 0 means you’re next
  final int totalOrders;

  @override
  State<TrackingDetails> createState() => _TrackingDetailsState();
}

class _TrackingDetailsState extends State<TrackingDetails> {
  late TrackingBloc trackingBloc;

  @override
  void initState() {
    super.initState();
    trackingBloc = context.read<TrackingBloc>();
  }

  @override
  void dispose() {
    trackingBloc.add(StopListening()); // Stop the tracking & WebSocket
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isActiveTracking = widget.positionInQueue <= 8;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B38),
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderInfoSection(widget.orderId),
            const SizedBox(height: 20),
            _yourPlaceSection(widget.positionInQueue, widget.totalOrders),
            const SizedBox(height: 20),
            isActiveTracking ? _activeMapSection() : _illustrationSection(),
          ],
        ),
      ),
    );
  }

  Widget _orderInfoSection(String orderId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order ID: $orderId", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            "Estimated Arrival Time:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text("Between 14:00 - 16:00"),
        ],
      ),
    );
  }

  Widget _yourPlaceSection(int positionInQueue, int totalOrders) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Your place in the route: ${positionInQueue + 1} out of $totalOrders",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _activeMapSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: BlocBuilder<TrackingBloc, TrackingState>(
          builder: (context, state) {
            if (state is TrackingUpdate) {
              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(state.latitude, state.longitude),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 50,
                        height: 50,
                        point: LatLng(state.latitude, state.longitude),
                        child: const Icon(
                          Icons.local_shipping,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is TrackingInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                child: Text("Waiting for driver's location..."),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _illustrationSection() {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/truck_waiting.png',
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            "Your order is queued.\nYou'll get access to live tracking when you're closer in line.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
