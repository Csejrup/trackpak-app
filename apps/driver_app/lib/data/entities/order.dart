class Order {
  final String id;
  final OrderStatus status;
  final OrderType type;
  final String? description;

  Order({
    required this.id,
    required this.status,
    required this.type,
    this.description,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      status: OrderStatus.fromString(json['status'] as String),
      type: OrderType.fromString(json['type'] as String),
      description: json['description'] as String?,
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

enum OrderType {
  service,
  package;

  factory OrderType.fromString(String type) {
    switch (type.toLowerCase()) {
      case 'service':
        return OrderType.service;
      case 'package':
        return OrderType.package;
      default:
        return OrderType.service;
    }
  }
}
