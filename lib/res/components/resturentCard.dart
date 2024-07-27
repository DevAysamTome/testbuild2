import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // لإضافة SharedPreferences

class RestaurantCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final List<String> categories;
  final List<Map<String, dynamic>> meals;

  RestaurantCard({
    required this.imageUrl,
    required this.title,
    required this.categories,
    required this.meals,
  });

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // تحقق مما إذا كان المفتاح موجودًا في SharedPreferences
      isFavorite = prefs.containsKey(widget.title);
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      Map<String, String> item = {
        'title': widget.title,
        'description': '${widget.title}', // استخدم وصفًا مناسبًا هنا
        'image': widget.imageUrl,
      };
      String jsonString = json.encode(item);

      if (isFavorite) {
        prefs.setString(
            widget.title, jsonString); // تخزين العنصر كـ JSON String
      } else {
        prefs.remove(widget.title); // إزالة العنصر
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                child: widget.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Placeholder(
                        fallbackHeight: 150,
                        color: Colors.grey,
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: widget.categories
                      .map((category) => Chip(label: Text(category)))
                      .toList(),
                ),
                SizedBox(height: 8),
                // عرض الوجبات إذا كانت متوفرة
              ],
            ),
          ),
        ],
      ),
    );
  }
}
