import 'package:driver_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> availableRoutes = [
    "Route A - City Center",
    "Route B - North Side",
    "Route C - Industrial Area",
  ];

  int? _selectedRouteIndex;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    String profileImage = '';

    if (authState is LoggedIn && authState.userProfile.pictureUrl != null) {
      profileImage = authState.userProfile.pictureUrl.toString();
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 11, 56),
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
                Text('Available Routes', style: TextStyle(fontSize: 18)),
                Text(
                  'Driver Dashboard',
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
          const SectionTitle(title: 'Routes to Assign'),
          ...List.generate(availableRoutes.length, (index) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.route, color: Colors.blue),
                title: Text(availableRoutes[index]),
                trailing: Radio<int>(
                  value: index,
                  groupValue: _selectedRouteIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedRouteIndex = value;
                    });
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          if (_selectedRouteIndex != null)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _assignRoute(context),
              icon: const Icon(Icons.assignment_ind),
              label: const Text("Assign Route to Me"),
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

  void _assignRoute(BuildContext context) async {
    final assignedRoute = availableRoutes[_selectedRouteIndex!];
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Assignment"),
            content: Text("Do you want to assign '$assignedRoute' to you?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Confirm"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      context.pushNamed(
        AppRoutes.routeDetails.name,
        pathParameters: {'routeName': assignedRoute},
      );

      // Navigate or show success
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ $assignedRoute assigned!")));
    }
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
