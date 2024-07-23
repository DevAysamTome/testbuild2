import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/controller/orderController.dart';
import 'package:user_app/models/meal.dart';
import 'package:user_app/views/home/resturent_view/meal_detial_view.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  RestaurantDetailsScreen({required this.restaurant});

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  List<Meal> meals = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    meals = List<Map<String, dynamic>>.from(widget.restaurant['meals'] ?? [])
        .map((mealData) => Meal(
            id: mealData['id'],
            name: mealData['mealName'],
            description: mealData['description'],
            price: mealData['price'],
            imageUrl: mealData['imageUrl'] ?? '',
            ingredients: mealData['ingredients'] ?? '',
            addOns: mealData['addOns'],
            category: mealData['category']))
        .toList();
    selectedCategory = '';
  }

  void filterMeals(String category) {
    setState(() {
      selectedCategory = category;
      if (category == '') {
        meals =
            List<Map<String, dynamic>>.from(widget.restaurant['meals'] ?? [])
                .map((mealData) => Meal(
                    id: mealData['id'],
                    name: mealData['mealName'],
                    description: mealData['description'],
                    price: mealData['price'],
                    imageUrl: mealData['imageUrl'] ?? '',
                    ingredients: mealData['ingredients'],
                    addOns: mealData['addOns'],
                    category: mealData['category']))
                .toList();
      } else {
        meals =
            List<Map<String, dynamic>>.from(widget.restaurant['meals'] ?? [])
                .map((mealData) => Meal(
                    id: mealData['id'],
                    name: mealData['mealName'],
                    description: mealData['description'],
                    price: mealData['price'],
                    imageUrl: mealData['imageUrl'] ?? '',
                    ingredients: mealData['ingredients'],
                    addOns: mealData['addOns'],
                    category: mealData['category']))
                .where((meal) => meal.category == category)
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurant['name'] ?? 'اسم غير متوفر'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Restaurant Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.restaurant['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Restaurant Name and Rating
            Text(
              widget.restaurant['name'] ?? 'اسم غير متوفر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.restaurant['description'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Delivery Info
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 24),
                    SizedBox(width: 4),
                    Text(
                      '${widget.restaurant['rating'] ?? 0}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.green, size: 24),
                    SizedBox(width: 4),
                    Text(
                      'توصيل ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.redAccent, size: 24),
                    SizedBox(width: 4),
                    Text(
                      '20 دقيقة',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Categories
            Text(
              'التصنيفات:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ChoiceChip(
                  label: Text('كل الوجبات'),
                  selected: selectedCategory == '',
                  onSelected: (selected) {
                    filterMeals('');
                  },
                  selectedColor: Colors.redAccent,
                ),
                ...List<String>.from(widget.restaurant['categories'] ?? [])
                    .map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      filterMeals(category);
                    },
                    selectedColor: Colors.redAccent,
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 16),

            // Meals
            Text(
              'المنتجات:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailsScreen(
                          meal: meal,
                          restaurant: widget.restaurant,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal Image
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            meal.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Meal Name
                              Text(
                                meal.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),

                              // Meal Description
                              Text(meal.description,
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(height: 4),

                              // Meal Price
                              Text(
                                'السعر: ${meal.price}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
