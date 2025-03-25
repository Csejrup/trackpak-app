import 'package:customer_app/core/router/routes.dart';
import 'package:customer_app/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const Text('My Orders', style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<OrderBloc>().add(FetchOrders());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthenticationBloc>().add(LogOut());
            },
          ),
        ],
      ),

      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            if (state.orders.isEmpty) return _buildEmptyState();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text('Order'),
                    trailing: Text(
                      order.status.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap:
                        () => context.pushNamed(
                          AppRoutes.trackingDetails.name,
                          pathParameters: {
                            "orderId": order.id,
                            "positionInQueue": "1",
                            "totalOrders": "5",
                          },
                        ),
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return _buildEmptyState();
        },
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No orders found!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
