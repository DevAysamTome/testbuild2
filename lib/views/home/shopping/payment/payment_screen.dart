import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cardProvider.dart';
import 'package:user_app/models/cartItem.dart';
import 'package:user_app/models/meal.dart';
import 'package:user_app/views/home/shopping/payment/add_card_screen.dart';
import 'package:user_app/models/order.dart' as od;
import 'package:user_app/models/cartProvider.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;
  final String? selectedAddress;
  final LatLng? selectedLocation;
  final LatLng? restaurantLocation;
  PaymentMethodScreen(
      {required this.cartItems,
      required this.totalPrice,
      required this.selectedAddress,
      required this.selectedLocation,
      required this.restaurantLocation,
      // تمريره كمعامل مطلوب هنا
      });

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentType _selectedPaymentType = PaymentType.cash; // افتراضيًا للدفع نقدًا

  Future<String> getNextOrderId() async {
    try {
      DocumentReference orderCounterRef =
          FirebaseFirestore.instance.doc('counters/orderCounter');

      return await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          DocumentSnapshot snapshot = await transaction.get(orderCounterRef);

          if (!snapshot.exists) {
            await transaction.set(orderCounterRef, {'count': 1});
            return '1';
          }

          if (snapshot.data() != null &&
              snapshot.data() is Map<String, dynamic>) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            int currentCount = data['count'] ?? 0;
            int nextCount = currentCount + 1;

            transaction.update(orderCounterRef, {'count': nextCount});

            return nextCount.toString();
          } else {
            throw Exception('Failed to find count value in counter document');
          }
        },
      );
    } catch (e) {
      print('Error getting next order ID: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentOption('Cash', Icons.money, PaymentType.cash),
                _buildPaymentOption(
                    'Visa', Icons.credit_card, PaymentType.visa),
                _buildPaymentOption(
                    'MasterCard', Icons.credit_card, PaymentType.masterCard),
                _buildPaymentOption(
                    'PayPal', Icons.account_balance_wallet, PaymentType.paypal),
              ],
            ),
            SizedBox(height: 32),
            _buildPaymentDetails(),
            Spacer(),
            Text(
              'Total: \$${widget.totalPrice}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final ordersToPlace = List<od.Order>.from(cartProvider.orders);

                for (var order in ordersToPlace) {
                  await cartProvider.placeOrder(
                      order.storeId,
                      widget.selectedAddress!,
                      widget.selectedLocation!,
                      order.items.first.restaurantLocation!,
                      // Assuming all items have the same restaurant location
                      );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully')),
                );
              },
              child: Text('Pay and Confirm'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.orange,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String label, IconData icon, PaymentType type) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentType = type;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: _selectedPaymentType == type ? Colors.orange : Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: _selectedPaymentType == type
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    switch (_selectedPaymentType) {
      case PaymentType.cash:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Logic for cash payment
            },
            child: Text('Complete Payment'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.orange,
            ),
          ),
        );
      case PaymentType.visa:
      case PaymentType.masterCard:
        return Consumer<CreditCardProvider>(
          builder: (context, creditCardProvider, _) {
            bool hasCards = creditCardProvider.creditCards.isNotEmpty;
            return Column(
              children: [
                if (hasCards)
                  ListTile(
                    leading: Icon(Icons.credit_card, size: 40),
                    title: Text('Master Card'),
                    subtitle: Text(
                      '**** **** **** ${creditCardProvider.creditCards.last.cardNumber.substring(12)}',
                    ),
                  ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCardScreen(),
                        ),
                      );
                    },
                    child: Text('Add New'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      case PaymentType.paypal:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Logic for PayPal payment
            },
            child: Text('Complete Payment via PayPal'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.orange,
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Future<void> _placeOrder(
    List<CartItem> cartItems,
    double totalPrice,
    String? selectedAddress,
    LatLng? selectedLocation,
    LatLng? restaurantLocation,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User must be logged in
      return;
    }

    try {
      String? orderId = await getNextOrderId();

      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');

      Map<String, dynamic> orderData = {
        'orderId': orderId,
        'userId': user.uid,
        'userEmail': user.email,
        'totalPrice': totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
        'items': cartItems.map((item) {
          return {
            'mealName': item.meal!.name,
            'imageUrl': item.meal!.imageUrl,
            'mealPrice': item.meal!.price,
            'quantity': item.quantity,
          };
        }).toList(),
        'orderStatus': 'Pending',
        'delivery_address': selectedAddress,
        'delivery_location': {
          'latitude': selectedLocation?.latitude,
          'longitude': selectedLocation?.longitude,
        },
        'restaurant_location': {
          'latitude': restaurantLocation?.latitude,
          'longitude': restaurantLocation?.longitude,
        },
      };

      await orders.doc(orderId).set(orderData);

      print('Created new order ID: $orderId');
      print('Selected location: $selectedLocation');
      print('Restaurant location: $restaurantLocation');
    } catch (e) {
      print('Error adding order to Firestore: $e');
    }
  }
}

enum PaymentType {
  cash,
  visa,
  masterCard,
  paypal,
}
