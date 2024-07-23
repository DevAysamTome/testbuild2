import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/models/cardProvider.dart';
import 'package:user_app/models/creditCard.dart';

class AddCardScreen extends StatelessWidget {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة بطاقة جديدة'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'رقم البطاقة',
                hintText: 'ادخل رقم البطاقة',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                labelText: 'تاريخ الانتهاء',
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _cvvController,
              decoration: InputDecoration(
                labelText: 'CVV',
                hintText: 'ادخل الرمز',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Create CreditCard object
                CreditCard card = CreditCard(
                  cardNumber: _cardNumberController.text,
                  expiryDate: _expiryDateController.text,
                  cvv: _cvvController.text,
                );
                
                // Add card using Provider
                Provider.of<CreditCardProvider>(context, listen: false).addCreditCard(card);

                // Navigate back to PaymentMethodsScreen
                Navigator.pop(context);
              },
              child: Text('إضافة البطاقة'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.orange,
              ),                                    
            ),
          ],
        ),
      ),
    );
  }
}
