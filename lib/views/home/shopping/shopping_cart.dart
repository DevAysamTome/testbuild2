import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cartProvider.dart';
import 'package:user_app/models/order.dart';
import 'package:user_app/views/home/shopping/addressDropDown.dart';
import 'package:user_app/views/home/shopping/payment/payment_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import this for LatLng

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? _selectedAddress;
  LatLng? _selectedLocation;
  LatLng? resturantLocation;
  LatLng? bevargeLocation;
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String userId = _auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF121223),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121223),
        title: const Text('عربة التسوق', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.orders.length,
              itemBuilder: (context, orderIndex) {
                var order = cartProvider.orders[orderIndex];

                return Card(
                  color: const Color(
                      0xFF1f1f2f), // Updated color for better contrast
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'متجر: ${order.storeId}', // Displaying store ID or store name
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'عدد العناصر: ${order.items.length}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Column(
                        children: order.items.map((item) {
                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2a2a39),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    item.meal.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.meal.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.meal.price}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'الإضافات: ${item.selectedAddOns!.join(', ')}', // Display selected add-ons
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.orange),
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        order.storeId,
                                        order.items.indexOf(item),
                                        item.quantity > 1
                                            ? item.quantity - 1
                                            : 1,
                                      );
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.orange),
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        order.storeId,
                                        order.items.indexOf(item),
                                        item.quantity + 1,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cartProvider.removeItem(
                                      order.storeId, order.items.indexOf(item));
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'عنوان التوصيل',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  AddressDropdown(
                    userId: userId,
                    onAddressSelected:
                        (String? selectedAddress, LatLng? selectedLocation) {
                      setState(() {
                        _selectedAddress = selectedAddress;
                        _selectedLocation = selectedLocation;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'المجموع:',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${cartProvider.totalPrice}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedAddress != null &&
                          _selectedLocation != null) {
                        // Create a copy of the orders list to avoid modification during iteration
                        final ordersToPlace =
                            List<Order>.from(cartProvider.orders);

                        for (var order in ordersToPlace) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentMethodScreen(
                                totalPrice: cartProvider.totalPrice,
                                cartItems: cartProvider.orders
                                    .expand((order) => order.items)
                                    .toList(),
                                selectedAddress: _selectedAddress,
                                selectedLocation: _selectedLocation,
                                restaurantLocation: ordersToPlace
                                    .first.items.first.restaurantLocation,
                              ),
                            ),
                          );
                          print(_selectedAddress);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('يرجى تحديد عنوان التوصيل والموقع.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'إتمام الطلب',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
