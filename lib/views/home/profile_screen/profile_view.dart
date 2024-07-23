import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cartProvider.dart';
import 'package:user_app/res/components/profileMenuItem.dart';
import 'package:user_app/views/home/profile_screen/faqs_view/faqs_screen.dart';
import 'package:user_app/views/home/profile_screen/faviroute_view/faviroute_Screen.dart';
import 'package:user_app/views/home/profile_screen/personal_details/address_delivery/address_screen.dart';
import 'package:user_app/views/home/profile_screen/personal_details/basic_information/basic_info.dart';
import 'package:user_app/views/home/profile_screen/users_review_view/users_review_screen.dart';
import 'package:user_app/views/home/shopping/payment/payment_screen.dart';
import 'package:user_app/views/home/shopping/shopping_cart.dart';
import 'package:user_app/views/login_views/login_view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    String? _selectedAddress;
    LatLng? _selectedLocation;
    String? userId;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.orangeAccent,
                  ),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'فيشال خادوك',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'أحب الوجبات السريعة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 241, 239, 239),
                    offset: Offset(0.1, 0.1),
                  ),
                ], borderRadius: BorderRadius.circular(18)),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      text: 'المعلومات الشخصية',
                      iconColor: Colors.deepOrange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.location_on_outlined,
                      text: 'العناوين',
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 241, 239, 239),
                    offset: Offset(0.1, 0.1),
                  ),
                ], borderRadius: BorderRadius.circular(18)),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.shopping_cart_outlined,
                      text: 'السلة',
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.favorite_outline,
                      text: 'المفضلة',
                      iconColor: Colors.pink,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritesScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.payment_outlined,
                      text: 'طريقة الدفع',
                      iconColor: Colors.purple,
                      onTap: () async {
                        for (var order in cartProvider.orders) {
                          await cartProvider.placeOrder(
                              order.storeId,
                              _selectedAddress!,
                              _selectedLocation!,
                              order.items.first.restaurantLocation!,
                              // Assuming all items have the same restaurant location
                              );

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
                                restaurantLocation:
                                    order.items.first.restaurantLocation,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 241, 239, 239),
                    offset: Offset(0.1, 0.1),
                  ),
                ], borderRadius: BorderRadius.circular(18)),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      text: 'الأسئلة الشائعة',
                      iconColor: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FAQScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.message_outlined,
                      text: 'اراء المستخدمين',
                      iconColor: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewsScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      text: 'الإعدادات',
                      iconColor: Colors.brown,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      text: 'تسجيل الخروج',
                      iconColor: Colors.red,
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen()), // استبدل بالشاشة التي ترغب في عرضها بعد تسجيل الخروج
                          (route) =>
                              false, // يزيل كافة الشاشات السابقة من الستاك
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
