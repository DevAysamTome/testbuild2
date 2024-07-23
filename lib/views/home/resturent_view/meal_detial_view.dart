import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cartItem.dart';
import 'package:user_app/models/cartProvider.dart';
import 'package:user_app/models/meal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MealDetailsScreen extends StatefulWidget {
  final Meal meal;
  final Map<String, dynamic> restaurant;

  MealDetailsScreen({required this.meal, required this.restaurant});

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  List<String> selectedAddOns = [];
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'التفاصيل',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the cart screen or display a dialog showing cart items.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('العناصر في السلة'),
                    content: Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        return ListView.builder(
                          itemCount: cartProvider.cartItemCount,
                          itemBuilder: (BuildContext context, int index) {
                            final cartItem = cartProvider.orders
                                .expand((order) => order.items)
                                .firstWhere(
                                    (item) => item.meal.id == widget.meal.id,
                                    orElse: () => CartItem(
                                          meal: widget.meal,
                                          quantity: 0,
                                          selectedAddOns: [],
                                          placeName: '',
                                          userLocation: LatLng(0, 0), // Use actual location
                                          restaurantLocation: LatLng(
                                              widget.restaurant['restaurant_location']
                                                      ['latitude'],
                                              widget.restaurant['restaurant_location']
                                                      ['longitude']),
                                          storeId: widget.restaurant['storeId'],
                                        ));
                            
                            return ListTile(
                              title: Text(cartItem.meal.name),
                              subtitle: Text('المطعم: ${widget.restaurant['name']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  cartProvider.removeItem(
                                      cartItem.storeId, index);
                                  Navigator.pop(context); // Close dialog after deleting item
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Image
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.meal.imageUrl,
                      fit: BoxFit.cover,
                      width: 300,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Restaurant Name
              Center(
                child: Chip(
                  avatar: const CircleAvatar(
                    backgroundImage: AssetImage("assets/icons/heart.png"),
                  ),
                  label: Text(
                    widget.restaurant['name'] ?? 'اسم المطعم',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Meal Name
              Center(
                child: Text(
                  widget.meal.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Meal Description
              Center(
                child: Text(
                  widget.meal.description,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Rating, Delivery, and Time
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.redAccent),
                      SizedBox(width: 4),
                      Text('4.7'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.delivery_dining, color: Colors.redAccent),
                      SizedBox(width: 4),
                      Text('متوفر'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.redAccent),
                      SizedBox(width: 4),
                      Text('20 دقيقة'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Size options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Chip(
                    label: const Text('10"'),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: const Text('14"'),
                    backgroundColor: Colors.orange[100],
                  ),
                  Chip(
                    label: const Text('16"'),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Ingredients
              const Text(
                'المكونات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: widget.meal.ingredients.map((ingredient) {
                  return ChoiceChip(
                    label: Text(ingredient),
                    selected: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Add-ons
              const Text(
                'الإضافات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: widget.meal.addOns.map((addOn) {
                  return ChoiceChip(
                    label: Text(addOn),
                    selected: selectedAddOns.contains(addOn),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedAddOns.add(addOn);
                        } else {
                          selectedAddOns.remove(addOn);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Price and Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.meal.price} ₪',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Add to Cart Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(
                      CartItem(
                          meal: widget.meal,
                          quantity: quantity,
                          selectedAddOns: selectedAddOns,
                          placeName: '',
                          userLocation: LatLng(0, 0), // Use actual location
                          restaurantLocation: LatLng(
                              widget.restaurant['restaurant_location']['latitude'],
                              widget.restaurant['restaurant_location']['longitude']),
                          storeId: widget.restaurant['storeId']),
                    );

                    // Reset selected addons and quantity after adding to cart
                    setState(() {
                      selectedAddOns = [];
                      quantity = 1;
                    });
                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تمت الإضافة إلى السلة'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('إضافة إلى السلة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}