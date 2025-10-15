import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hgocery_app/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      print("Foydalanuvchi topilmadi!");
      return;
    }

    var uid = user.uid;
    print("Orders yuklanmoqda. User ID: $uid");

    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .orderBy('orderDate', descending: true)
          .get();

      print("Firestore dan ${ordersSnapshot.docs.length} ta order topildi");

      _orders = [];

      for (var element in ordersSnapshot.docs) {
        var data = element.data() as Map<String, dynamic>;
        print("Order data: $data");

        // Field nomlarini to'g'rilash
        _orders.add(
          OrderModel(
            orderId: data['orderId'] ?? '',
            userId: data['userId'] ?? '',
            productId: data['productId'] ?? '',
            userName: data['userName'] ?? 'Mijoz',
            price:
                data['totalPrice']?.toString() ?? '0', // ✅ totalPrice ishlating
            imageUrl: data['imageUrl'] ?? '', // ✅ imageUrl mavjud
            quantity: data['quantity']?.toString() ?? '1',
            orderDate: data['orderDate'] ?? Timestamp.now(),
          ),
        );
      }

      print("OrdersProvider da ${_orders.length} ta order saqlandi");
      notifyListeners();
    } catch (e) {
      print("Firestore xatolik: $e");
    }
  }
}
