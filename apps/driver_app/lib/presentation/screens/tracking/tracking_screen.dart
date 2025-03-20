import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 11, 56),
        title: Row(
          children: [
            /*  const CircleAvatar(backgroundImage: AssetImage('placeholder.png')), */
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('My trackings', style: TextStyle(fontSize: 18)),
                Text(
                  'Overview',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: const [Icon(Icons.help_outline)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SectionTitle(title: 'Today'),
          TrackingCard(
            title: 'Jysk.dk',
            carrier: 'GLS',
            status: 'Delivering',
            statusColor: Colors.orange,
            eta: '02t 23 min',
            etaColor: Colors.amber,
            date: '14-01-2025',
          ),
          TrackingCard(
            title: 'YouSee',
            carrier: 'Technician',
            status: 'On Route',
            statusColor: Colors.orange,
            eta: '23 min',
            etaColor: Colors.amber,
            date: '14-01-2025',
          ),
          TrackingCard(
            title: 'Coolshop.dk',
            carrier: 'Post Nord',
            status: 'Arrived',
            statusColor: Colors.green,
            eta: 'Delivered',
            etaColor: Colors.green,
            date: '14-01-2025',
          ),
          const SectionTitle(title: 'Upcoming'),
          TrackingCard(
            title: 'Elgiganten.dk',
            carrier: 'Post Nord',
            status: 'Transit',
            statusColor: Colors.orange,
            eta: 'Being packaged',
            etaColor: Colors.orange.shade200,
            date: '16-01-2025',
          ),
          TrackingCard(
            title: 'Murermester Salting',
            carrier: 'Builder',
            status: 'Awaiting',
            statusColor: Colors.orange,
            eta: '',
            etaColor: Colors.orange,
            date: '18-01-2025',
          ),
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
  final String title, carrier, status, eta, date;
  final Color statusColor, etaColor;

  const TrackingCard({
    super.key,
    required this.title,
    required this.carrier,
    required this.status,
    required this.statusColor,
    required this.eta,
    required this.etaColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(title),
            subtitle: Text(carrier),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(date, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (eta.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: etaColor.withOpacity(0.3),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    eta,
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
}
