import 'package:flutter/material.dart';

class TrackingDetails extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool isActiveTracking = positionInQueue <= 8;

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
            _orderInfoSection(),
            const SizedBox(height: 20),
            _yourPlaceSection(),
            const SizedBox(height: 20),
            isActiveTracking ? _activeMapSection() : _illustrationSection(),
          ],
        ),
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
    );
  }

  Widget _orderInfoSection() {
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

  Widget _yourPlaceSection() {
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
        child: const Center(
          child: Text(
            "🗺 Live Map Tracking Activated",
            style: TextStyle(fontSize: 16),
          ),
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
