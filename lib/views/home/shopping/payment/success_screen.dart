import 'package:flutter/material.dart';
import 'package:user_app/views/home/home_component.dart';

class PaymentSuccessScreen extends StatelessWidget {

  PaymentSuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Navigate back to HomeComponent with cartItems
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeComponent()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'تم الدفع بنجاح',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'شكراً لتسوقك معنا! تم إتمام عملية الدفع بنجاح.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate back to HomeComponent with cartItems
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeComponent()),
                );
              },
              child: Text(
                'الرجوع إلى الصفحة الرئيسية',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Elmassry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
