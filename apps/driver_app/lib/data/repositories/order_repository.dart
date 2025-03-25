import 'package:driver_app/data/entities/order.dart';
import 'package:shared/providers/providers.dart';

class OrderRepository {
  final ApiProvider apiProvider;

  OrderRepository(this.apiProvider);

  Future<List<Order>> fetchOrders() async {
    final response = await apiProvider.getRequest('/orders');
    if (response?.statusCode == 200) {
      final List<dynamic> data = response!.data;
      return data.map((json) => Order.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch orders');
  }
}
