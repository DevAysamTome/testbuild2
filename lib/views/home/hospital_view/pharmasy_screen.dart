import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/res/components/resturentCard.dart';

class PharmacyScreen extends StatefulWidget {
  @override
  _PharmacyScreenState createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  late Future<List<Map<String, dynamic>>> pharmaciesFuture;

  @override
  void initState() {
    super.initState();
    pharmaciesFuture = fetchPharmaciesData();
  }

  Future<List<Map<String, dynamic>>> fetchPharmaciesData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pharmacies').get();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('المطاعم'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: pharmaciesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final pharmacies = snapshot.data ?? [];
            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> pharmacie = pharmacies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PharmacyScreen(
                         
                        ),
                      ),
                    );
                  },
                  child: RestaurantCard(
                    imageUrl: pharmacie['imageUrl'] ?? '',
                    title: pharmacie['name'] ?? 'اسم غير متوفر',
                    categories:
                        List<String>.from(pharmacie['categories'] ?? []),
                    meals: List<Map<String, dynamic>>.from(
                        pharmacie['meals'] ?? []),
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
