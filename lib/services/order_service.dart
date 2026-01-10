import '../models/orders.dart';

class OrdersService {
  static final List<Order> _orders = [];

  static List<Order> getAllOrders() {
    return List.unmodifiable(_orders);
  }

  static void addOrder(Order order) {
    _orders.insert(0, order);
  }

  static void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = Order(
        id: order.id,
        product: order.product,
        buyerName: order.buyerName,
        contactNumber: order.contactNumber,
        meetupLocation: order.meetupLocation,
        notes: order.notes,
        orderDate: order.orderDate,
        status: newStatus,
      );
    }
  }

  static void deleteOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
  }
}
