import 'product.dart';

class Order {
  final String id;
  final Product product;
  final String buyerName;
  final String contactNumber;
  final String meetupLocation;
  final String? notes;
  final DateTime orderDate;
  final String status;

  Order({
    required this.id,
    required this.product,
    required this.buyerName,
    required this.contactNumber,
    required this.meetupLocation,
    this.notes,
    required this.orderDate,
    this.status = 'pending',
  });
}
