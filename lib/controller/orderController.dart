import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Stream<QuerySnapshot> getOngoingOrders() {
    return ordersCollection
        .where('orderStatus',
            isEqualTo:
                'قيد التنفيذ') // يمكنك تعديل الحالة هنا حسب الحقل المستخدم في Firestore
        .snapshots();
  }

  Stream<QuerySnapshot> getOrderHistory() {
    return ordersCollection
        .where('orderStatus',
            isEqualTo:
                'ملغي') // يمكنك تعديل الحالة هنا حسب الحقل المستخدم في Firestore
        .snapshots();
  }
}
