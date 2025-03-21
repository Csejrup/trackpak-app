import 'package:customer_app/data/repositories/order_repository.dart';
import 'package:customer_app/domain/entities/order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc(this.repository) : super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final List<Order> orders = await repository.fetchOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError("Failed to fetch orders: ${e.toString()}"));
    }
  }
}
