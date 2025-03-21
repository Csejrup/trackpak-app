part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchOrders extends OrderEvent {}
