import 'package:flutter/material.dart';
import 'package:user_app/res/components/favirouteItem.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites = [
    {
      'title': 'منتج 1',
      'description': 'وصف المنتج 1',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'منتج 2',
      'description': 'وصف المنتج 2',
      'image': 'https://via.placeholder.com/150',
    },
    // أضف المزيد من المنتجات هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'المفضلة',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favorites.isEmpty
            ? Center(
                child: Text(
                  'لا توجد عناصر في المفضلة',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return FavoriteItem(
                    title: favorites[index]['title']!,
                    description: favorites[index]['description']!,
                    image: favorites[index]['image']!,
                  );
                },
              ),
      ),
    );
  }
}

