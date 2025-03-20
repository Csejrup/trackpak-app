import 'package:driver_app/presentation/blocs/tracking_bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key, required this.routeName});
  final String routeName;

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool hasStarted = false;

  final List<String> orders = [
    "Order #1 - Jysk.dk",
    "Order #2 - YouSee",
    "Order #3 - Coolshop.dk",
    "Order #4 - Elgiganten.dk",
    "Order #5 - Murermester Salting",
  ];

  @override
  Widget build(BuildContext context) {
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
                  "Top 5 Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...orders.map(
                  (order) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.local_shipping),
                      title: Text(order),
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
                      setState(() {
                        hasStarted = true;
                      });
                      // ✅ Trigger tracking
                      context.read<TrackingBloc>().add(
                        StartTracking(
                          driverId: "driver-1234",
                          wsUrl: "wss://your-backend-endpoint/ws/tracking",
                        ),
                      );
                    },
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
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}
