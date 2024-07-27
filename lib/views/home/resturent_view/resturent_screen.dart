import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/res/components/resturentCard.dart';
import 'package:user_app/views/home/resturent_view/resturent_details.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  late Future<List<Map<String, dynamic>>> restaurantsFuture;
  List<String> categories = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    restaurantsFuture = fetchRestaurantsData();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('restaurants').get();

    Set<String> categorySet = {};
    for (var doc in querySnapshot.docs) {
      List<String> restaurantCategories =
          List<String>.from(doc['categories'] ?? []);
      categorySet.addAll(restaurantCategories);
    }

    setState(() {
      categories = ['All', ...categorySet];
    });
  }

  Future<List<Map<String, dynamic>>> fetchRestaurantsData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('restaurants').get();
    return Future.wait(querySnapshot.docs.map((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Check if sub-collection 'meals' exists
      QuerySnapshot mealsSnapshot =
          await doc.reference.collection('meals').get();
      if (mealsSnapshot.docs.isNotEmpty) {
        data['meals'] = mealsSnapshot.docs.map((doc) => doc.data()).toList();
      }
      return data;
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(
              'المطاعم',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              // ListView for categories as horizontal carousel
              Container(
                height: 50, // Set height for ListView
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(categories[index]),
                        selected: selectedCategory == categories[index],
                        onSelected: (bool selected) {
                          setState(() {
                            selectedCategory =
                                selected ? categories[index] : 'All';
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: restaurantsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final restaurants = snapshot.data ?? [];
                    final filteredRestaurants = selectedCategory == 'All'
                        ? restaurants
                        : restaurants.where((restaurant) {
                            List<String> restaurantCategories =
                                List<String>.from(
                                    restaurant['categories'] ?? []);
                            return restaurantCategories
                                .contains(selectedCategory);
                          }).toList();
                    return ListView.builder(
                      itemCount: filteredRestaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> restaurant =
                            filteredRestaurants[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailsScreen(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          },
                          child: RestaurantCard(
                            imageUrl: restaurant['imageUrl'] ?? '',
                            title: restaurant['name'] ?? 'اسم غير متوفر',
                            categories: List<String>.from(
                                restaurant['categories'] ?? []),
                            meals: List<Map<String, dynamic>>.from(
                                restaurant['meals'] ?? []),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
