import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/res/components/orderCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersList extends StatelessWidget {
  final List<DocumentSnapshot> orders;
  final bool isOngoing;

  OrdersList({required this.orders, required this.isOngoing});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final orderData = orders[index].data();
        if (orderData == null) {
          return SizedBox.shrink(); // يمكن عرض عنصر فارغ أو رسالة خطأ
        }

        final order = orderData as Map<String, dynamic>;

        // معالجة items
        final items = order['items'] as List<dynamic>? ?? [];
        final firstItemImageUrl = items.isNotEmpty
            ? (items[0] as Map<String, dynamic>)['meal']['imageUrl']
                    as String? ??
                ''
            : '';

        // معالجة مواقع
        final firstItemData =
            items.isNotEmpty ? items[0] as Map<String, dynamic> : {};
        final userLocationArray =
            firstItemData['userLocation'] as List<dynamic>? ?? [];
        final orderLocation = LatLng(
          userLocationArray.isNotEmpty && userLocationArray[0] is double
              ? userLocationArray[0] as double
              : 0.0,
          userLocationArray.length > 1 && userLocationArray[1] is double
              ? userLocationArray[1] as double
              : 0.0,
        );

        final restaurantLocationArray =
            firstItemData['restaurantLocation'] as List<dynamic>? ?? [];
        final restaurantLocation = LatLng(
          restaurantLocationArray.isNotEmpty &&
                  restaurantLocationArray[0] is double
              ? restaurantLocationArray[0] as double
              : 0.0,
          restaurantLocationArray.length > 1 &&
                  restaurantLocationArray[1] is double
              ? restaurantLocationArray[1] as double
              : 0.0,
        );

        // معالجة orderEndTime
        final orderEndTimeTimestamp = order['orderEndTime'] as Timestamp?;
        final orderEndTime = orderEndTimeTimestamp?.toDate();

        return OrderCard(
          imageUrl: firstItemImageUrl,
          title: order['restaurantName'] as String? ??
              '', // تأكد من استخدام اسم الحقل الصحيح
          price: '${order['totalPrice']} شيكل',
          itemsList: items.map((item) {
            final itemData = item as Map<String, dynamic>;
            final meal = itemData['meal'] as Map<String, dynamic>;

            return {
              'mealName': meal['name'],
              'imageUrl': meal['imageUrl'],
              'mealPrice': meal['price'],
              'quantity': itemData['quantity'] as int? ?? 0,
            };
          }).toList(),
          orderNumber: order['orderId'],
          status: order['orderStatus'],
          date: order['timestamp'] != null
              ? (order['timestamp'] as Timestamp).toDate().toString()
              : null,
          isOngoing: isOngoing,
          type: order['type'] as String? ?? '',
          orderLocation: orderLocation,
          restaurantLocation: restaurantLocation,
          orderEndTime: orderEndTime, // إضافة orderEndTime هنا
        );
      },
    );
  }
}
