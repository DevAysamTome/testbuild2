import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cartProvider.dart';
import 'package:user_app/res/components/buildCategoryCard.dart';
import 'package:user_app/res/components/buildDetailsStoreCategory.dart';
import 'package:user_app/res/components/menu_drawer.dart';
import 'package:user_app/views/home/drink_view/drink_details.dart';
import 'package:user_app/views/home/drink_view/drink_screen.dart';
import 'package:user_app/views/home/hospital_view/pharmasy_details_view.dart';
import 'package:user_app/views/home/hospital_view/pharmasy_screen.dart';
import 'package:user_app/views/home/resturent_view/resturent_details.dart';
import 'package:user_app/views/home/resturent_view/resturent_screen.dart';
import 'package:user_app/views/home/search_view/search_view.dart';
import 'package:user_app/views/home/shopping/shopping_cart.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<Map<String, dynamic>>> restaurantsFuture;
  late Future<List<Map<String, dynamic>>> pharmaciesFuture;
  late Future<List<Map<String, dynamic>>> beverageStoresFuture;

  @override
  void initState() {
    super.initState();
    restaurantsFuture = fetchCollectionData('restaurants');
    pharmaciesFuture = fetchCollectionData('pharmacies');
    beverageStoresFuture = fetchCollectionData('beverageStores');
  }

  Future<List<Map<String, dynamic>>> fetchCollectionData(
      String collectionName) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    List<Map<String, dynamic>> dataList = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Fetch sub-collection 'meals' for each document
      QuerySnapshot mealsSnapshot =
          await doc.reference.collection('meals').get();

      List<Map<String, dynamic>>? mealsList = [];
      if (mealsSnapshot.docs.isNotEmpty) {
        mealsList = mealsSnapshot.docs
            .map((mealDoc) => mealDoc.data())
            .cast<Map<String, dynamic>>()
            .toList();
      }

      // Add meals list to the data map
      data['meals'] = mealsList;

      // Add the combined data to the dataList
      dataList.add(data);
    }

    return dataList;
  }

  String getGreetingText() {
    var now = DateTime.now();
    var hour = now.hour;
    var greetingText = '';

    if (hour < 12) {
      greetingText = 'صباحك عربي بالصلاة عالنبي، شو حابب تفطر اليوم؟';
    } else if (hour >= 12 && hour < 17) {
      greetingText = 'شو حابب تتغدا معنا اليوم؟';
    } else {
      greetingText = 'شو حابب تتعشى معنا اليوم؟';
    }

    return greetingText;
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var greetingText = getGreetingText();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu, size: 40, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag,
                          size: 40, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 30,
                      left: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 10,
                        child: Center(
                          child: Text(
                            '${cartProvider.cartItemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    greetingText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SearchWidget(),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryCard(
                          icon: "assets/icons/burger.png",
                          title: "المطاعم",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantsScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        CategoryCard(
                          icon: "assets/icons/drink-logo.png",
                          title: "المشروبات",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BeverageStoresScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        CategoryCard(
                          icon: "assets/icons/pharmacy.png",
                          title: "الصيدليات",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PharmacyScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                CategoryCards(
                  title: ' المطاعم المتاحة حاليا',
                  futureData: restaurantsFuture,
                  onTap: (restaurant) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailsScreen(
                          restaurant: restaurant,
                        ),
                      ),
                    );
                  },
                ),
                CategoryCards(
                  title: 'الصيدليات المتاحة حاليا',
                  futureData: pharmaciesFuture,
                  onTap: (pharmacy) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PharmasyDetailsScreen(
                          pharmacy: pharmacy,
                        ),
                      ),
                    );
                  },
                ),
                CategoryCards(
                  title: 'محلات المشروبات المتاحة حاليا',
                  futureData: beverageStoresFuture,
                  onTap: (beverageStore) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeverageStoreDetailsScreen(
                          beverageStore: beverageStore,
                        ),
                      ),
                    );
                  },
                ), // CategoryCards widgets and other content
              ],
            ),
          ),
        ),
      ),
    );
  }
}
