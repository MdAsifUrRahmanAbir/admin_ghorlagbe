import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  final double price, totalPrice;
  final String productId, userId, imageUrl, userName, userNumber, userEmail, orderId;
  final int quantity;
  final Timestamp orderDate;

  OrderModel({
    required this.price,
    required this.totalPrice,
    required this.productId,
    required this.userId,
    required this.orderId,
    required this.imageUrl,
    required this.userName,
    required this.userNumber,
    required this.userEmail,
    required this.quantity,
    required this.orderDate
  });
}