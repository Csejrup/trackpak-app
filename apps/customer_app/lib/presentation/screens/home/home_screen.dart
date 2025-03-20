import 'package:customer_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> todayTrackings = const [
    {
      "title": "Jysk.dk",
      "carrier": "GLS",
      "status": "Delivering",
      "statusColor": "orange",
      "eta": "02t 23 min",
      "etaColor": "amber",
      "date": "14-01-2025",
    },
    {
      "title": "YouSee",
      "carrier": "Technician",
      "status": "On Route",
      "statusColor": "orange",
      "eta": "23 min",
      "etaColor": "amber",
      "date": "14-01-2025",
    },
    {
      "title": "Coolshop.dk",
      "carrier": "Post Nord",
      "status": "Arrived",
      "statusColor": "green",
      "eta": "Delivered",
      "etaColor": "green",
      "date": "14-01-2025",
    },
  ];

  final List<Map<String, String>> upcomingTrackings = const [
    {
      "title": "Elgiganten.dk",
      "carrier": "Post Nord",
      "status": "Transit",
      "statusColor": "orange",
      "eta": "Being packaged",
      "etaColor": "orangeLight",
      "date": "16-01-2025",
    },
    {
      "title": "Murermester Salting",
      "carrier": "Builder",
      "status": "Awaiting",
      "statusColor": "orange",
      "eta": "",
      "etaColor": "orange",
      "date": "18-01-2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isEmpty = todayTrackings.isEmpty && upcomingTrackings.isEmpty;
    final authState = context.watch<AuthenticationBloc>().state;
    String profileImage = '';

    if (authState is LoggedIn && authState.userProfile.pictureUrl != null) {
      profileImage = authState.userProfile.pictureUrl.toString();
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B38),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : const AssetImage(
                            'assets/images/profile_placeholder.png',
                          )
                          as ImageProvider,
            ),

            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'My Trackings',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'Overview',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: const [Icon(Icons.help_outline, color: Colors.white)],
      ),
      body:
          isEmpty
              ? _buildEmptyState()
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (todayTrackings.isNotEmpty) ...[
                    const SectionTitle(title: "Today"),
                    ...todayTrackings.map(
                      (tracking) => TrackingCard(data: tracking),
                    ),
                  ],
                  if (upcomingTrackings.isNotEmpty) ...[
                    const SectionTitle(title: "Upcoming"),
                    ...upcomingTrackings.map(
                      (tracking) => TrackingCard(data: tracking),
                    ),
                  ],
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No active trackings yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Track your packages here once they are added.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TrackingCard extends StatelessWidget {
  final Map<String, String> data;

  const TrackingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(data["title"]!),
            subtitle: Text(data["carrier"]!),
            onTap:
                () => context.pushNamed(
                  AppRoutes.trackingDetails.name,
                  pathParameters: {
                    "orderId": "123",
                    "positionInQueue": "1",
                    "totalOrders": "5",
                  },
                ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data["status"]!,
                  style: TextStyle(
                    color: _getStatusColor(data["statusColor"]!),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(data["date"]!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (data["eta"]!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _getEtaColor(data["etaColor"]!).withOpacity(0.3),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    data["eta"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.home, size: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String color) {
    switch (color) {
      case "green":
        return Colors.green;
      case "orange":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getEtaColor(String color) {
    switch (color) {
      case "green":
        return Colors.green;
      case "amber":
        return Colors.amber;
      case "orangeLight":
        return Colors.orange.shade200;
      default:
        return Colors.grey;
    }
  }
}
