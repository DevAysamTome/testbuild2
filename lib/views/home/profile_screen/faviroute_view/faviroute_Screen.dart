import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/res/components/favirouteItem.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<Map<String, String>>> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();
    List<Map<String, String>> favorites = [];

    for (String key in keys) {
      dynamic value = prefs.get(key);
      if (value is String) {
        try {
          Map<String, dynamic> item = json.decode(value);
          favorites.add({
            'key': key,
            'title': item['title'] as String? ?? 'No Title',
            'description': item['description'] as String? ?? 'No Description',
            'image': item['image'] as String? ?? 'No Image',
          });
        } catch (e) {
          print('Error decoding JSON for key $key: $e');
        }
      } else {
        print('Unexpected data type for key $key: ${value.runtimeType}');
      }
    }
    return favorites;
  }

  void _removeFavorite(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    setState(() {}); // إعادة تحميل البيانات بعد الحذف
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'المفضلة',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Map<String, String>>>(
          future: _loadFavorites(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('خطأ في تحميل البيانات: ${snapshot.error}'),
              );
            }

            List<Map<String, String>> favorites = snapshot.data ?? [];
            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد عناصر في المفضلة',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            favorites[index]['image']!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favorites[index]['title']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                favorites[index]['description']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('تأكيد الحذف'),
                                  content: Text(
                                      'هل أنت متأكد أنك تريد حذف هذا العنصر من المفضلة؟'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('إلغاء'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _removeFavorite(
                                            favorites[index]['key']!);
                                      },
                                      child: Text('حذف'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
