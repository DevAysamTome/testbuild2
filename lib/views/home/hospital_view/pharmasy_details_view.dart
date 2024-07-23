import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PharmasyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> pharmacy;

  PharmasyDetailsScreen({required this.pharmacy});

  @override
  _PharmasyDetailsScreenState createState() => _PharmasyDetailsScreenState();
}

class _PharmasyDetailsScreenState extends State<PharmasyDetailsScreen> {
  TextEditingController _medicineNameController = TextEditingController();
  bool _uploadPrescription = false;
  File? _prescriptionImage; // Variable to store uploaded image

  @override
  void initState() {
    super.initState();
  }

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
                        _getImageFromGallery(); // Activate image picker
                      } else {
                        _prescriptionImage = null; // Clear image if unchecked
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

            // Button to Place Order
            ElevatedButton(
              onPressed: () {
                // Implement order placement logic here
                _medicineNameController.text.trim();
                // Use medicineName and _prescriptionImage as needed
                // Example: Navigator.push to a confirmation screen or handle the order directly
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'اطلب',
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
