import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final List<String> categories;
  final List<Map<String, dynamic>> meals; // Define meals parameter

  RestaurantCard({
    required this.imageUrl,
    required this.title,
    required this.categories,
    required this.meals, // Add meals parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Placeholder(
                  fallbackHeight: 150,
                  color: Colors.grey,
                ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: categories
                    .map((category) => Chip(label: Text(category)))
                    .toList(),
              ),
              SizedBox(height: 8),
              // Display meals if available
            ],
          ),
        ),
      ]),
    );
  }
}
