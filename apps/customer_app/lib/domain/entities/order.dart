class Order {
  final String id;
  final String title;
  final OrderStatus status;
  final DateTime estimatedArrival;
  final String carrier;
  final String address;
  final String? employeeId;

  Order({
    required this.id,
    required this.title,
    required this.status,
    required this.estimatedArrival,
    required this.carrier,
    required this.address,
    this.employeeId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      title: json['title'] as String,
      status: OrderStatus.fromString(json['status'] as String),
      estimatedArrival: DateTime.parse(json['estimatedArrival']),
      carrier: json['carrier'] as String,
      address: json['address'] as String,
      employeeId: json['employeeId'] as String?,
    );
  }
}

enum OrderStatus {
  pending,
  inProgress,
  shipped,
  delivered,
  cancelled;

  factory OrderStatus.fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'inprogress':
        return OrderStatus.inProgress;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
