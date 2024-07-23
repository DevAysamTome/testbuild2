import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController _nameController =
      TextEditingController(text: 'Vishal Khadok');
  final TextEditingController _emailController =
      TextEditingController(text: 'hello@halallab.co');
  final TextEditingController _phoneController =
      TextEditingController(text: '408-841-0926');
  final TextEditingController _bioController =
      TextEditingController(text: 'I love fast food');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'المعلومات الاساسية',
            style: TextStyle(fontFamily: 'Elmassry'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.white, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'السيرة الذاتية',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // ضع هنا منطق حفظ المعلومات المعدلة
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'حفظ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
