import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cartItem.dart';
import 'package:user_app/models/cartProvider.dart';
import 'package:user_app/models/meal.dart';

class PharmasyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> pharmacy;

  PharmasyDetailsScreen({required this.pharmacy});

  @override
  _PharmasyDetailsScreenState createState() => _PharmasyDetailsScreenState();
}

class _PharmasyDetailsScreenState extends State<PharmasyDetailsScreen> {
  TextEditingController _medicineNameController = TextEditingController();
  bool _uploadPrescription = false;
  File? _prescriptionImage;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _medicineNameController.dispose();
    super.dispose();
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _prescriptionImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadPrescriptionImage() async {
    if (_prescriptionImage == null) return null;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('prescriptions/$fileName');
      UploadTask uploadTask = ref.putFile(_prescriptionImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _addToCart() async {
    String medicineName = _medicineNameController.text.trim();
    String? prescriptionImageUrl = await _uploadPrescriptionImage();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // استخدام Meal مع معلومات الدواء
    cartProvider.addItem(CartItem(
      meal: Meal(
        id: widget.pharmacy['storeId'] ??
            'unknown', // استخدام storeId كمعرف للدواء
        name: medicineName, // اسم الدواء
        description: widget.pharmacy['description'] ??
            'لا يوجد وصف', // وصف الصيدلية كبديل
        price: 0, // السعر الافتراضي للدواء إذا كان غير محدد
        imageUrl:
            widget.pharmacy['imageUrl'], // صورة فارغة أو صورة افتراضية للدواء
        ingredients: [], // لا يوجد مكونات هنا
        addOns: [], // لا يوجد إضافات هنا
        category: 'صيدلية', // تصنيف ثابت للصيدلية
      ),
      quantity: 1,
      placeName: widget.pharmacy['name'] ?? 'اسم غير متوفر',
      userLocation: LatLng(0, 0), // موقع المستخدم، استخدم الموقع الفعلي إن أمكن
      restaurantLocation: LatLng(
        widget.pharmacy['pharmcies_location']['latitude'],
        widget.pharmacy['pharmcies_location']['longitude'],
      ),
      storeId: widget.pharmacy['storeId'],
      prescriptionImageUrl: prescriptionImageUrl, // إضافة صورة الروشتة إن وجدت
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إضافة الطلب إلى السلة')),
    );

    // الانتقال إلى شاشة السلة أو أي شاشة أخرى إذا لزم الأمر
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.pharmacy['name'] ?? 'اسم غير متوفر'),
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
            // Pharmacy Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.pharmacy['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Pharmacy Name
            Text(
              widget.pharmacy['name'] ?? 'اسم غير متوفر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),

            // Pharmacy Description
            Text(
              widget.pharmacy['description'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Delivery Info and Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 24),
                    SizedBox(width: 4),
                    Text(
                      '0',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.green, size: 24),
                    SizedBox(width: 4),
                    Text(
                      'توصيل',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
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

            // Option 1: Enter Medicine Name
            TextFormField(
              controller: _medicineNameController,
              decoration: InputDecoration(
                labelText: 'اسم الدواء أو المنتج المطلوب',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Option 2: Upload Prescription
            Row(
              children: [
                Checkbox(
                  value: _uploadPrescription,
                  onChanged: (value) {
                    setState(() {
                      _uploadPrescription = value!;
                      if (_uploadPrescription) {
                        _getImageFromGallery();
                      } else {
                        _prescriptionImage = null;
                      }
                    });
                  },
                ),
                Text('رفع صورة روشتة طبية'),
              ],
            ),
            SizedBox(height: 16),

            // Display Uploaded Prescription Image
            if (_prescriptionImage != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_prescriptionImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 16),

            // Button to Add to Cart
            ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'أضف إلى السلة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
