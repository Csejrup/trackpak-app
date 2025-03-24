import 'package:driver_app/presentation/blocs/tracking_bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';

class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key, required this.routeName});
  final String routeName;

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool hasStarted = false;

  final List<Map<String, String>> orders = [
    {
      "orderName": "Order #1 - Jysk.dk",
      "userId": "409a2b0c-0bfa-459c-b782-82a914bec178",
    },
    {
      "orderName": "Order #2 - YouSee",
      "userId": "409a2b0c-0bfa-459c-b782-82a914bec179",
    },
  ];
  @override
  void dispose() {
    context.read<TrackingBloc>().add(StopTracking()); // Send stop event
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    final employeeId = authState is LoggedIn ? authState.employeeId : null;
    final accessToken = authState is LoggedIn ? authState.accessToken : null;
    print(employeeId);
    return BlocProvider(
      create: (_) => TrackingBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        appBar: AppBar(
          backgroundColor: const Color(0xFF070B38),
          title: Row(
            children: [
              const Icon(Icons.route, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.routeName,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<TrackingBloc, TrackingState>(
          builder: (context, trackingState) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Top Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...orders.map(
                  (order) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.local_shipping),
                      title: Text(order['orderName']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "🗺 Map Placeholder",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (!hasStarted)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      "Start Route",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      if (employeeId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Employee ID missing")),
                        );
                        return;
                      }
                      setState(() {
                        hasStarted = true;
                      });

                      // ✅ Trigger tracking with employeeId and userId
                      context.read<TrackingBloc>().add(
                        StartTracking(
                          driverId: employeeId,
                          wsUrl:
                              "wss://mongrel-active-completely.ngrok-free.app/api/tracking/ws?employeeId=$employeeId",
                          accessToken: accessToken!,
                        ),
                      );
                    }, //       "wss://mongrel-active-completely.ngrok-free.app/api/tracking/ws?employeeId=$employeeId&userId=$userId",
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        trackingState is TrackingInProgress
                            ? "✅ Route Started - Tracking Location..."
                            : "✅ Route Started",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
