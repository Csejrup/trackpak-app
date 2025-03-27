import 'package:customer_app/core/router/routes.dart';
import 'package:customer_app/domain/entities/order.dart';
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
      backgroundColor: const Color(0xFF070B38),
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
              children: [
                Text(
                  'My Trackings',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color.fromARGB(255, 176, 176, 176),
                  ),
                ),
              ],
            ),
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
            return Container(
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _buildDeliveryCard(context, order);
                },
              ),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return _buildEmptyState();
        },
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

  Widget _buildDeliveryCard(BuildContext context, Order order) {
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            AppRoutes.trackingDetails.name,
            pathParameters: {
              "orderId": order.id,
              "positionInQueue": "1",
              "totalOrders": "5",
            },
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFBF9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top row with company and status
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF0B0C3F),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jysk.dk",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "GLS",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "• Delivering",
                      style: TextStyle(color: Color(0xFFE8B300)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "14-01-2025",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),

            const SizedBox(height: 12),

            // Bottom progress bar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EAD2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8B300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.local_shipping, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "02 t 23 min",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.home_outlined, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
