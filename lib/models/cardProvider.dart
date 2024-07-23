import 'package:flutter/material.dart';
import 'package:user_app/models/creditCard.dart';

class CreditCardProvider extends ChangeNotifier {
  List<CreditCard> _creditCards = [];

  List<CreditCard> get creditCards => _creditCards;

  void addCreditCard(CreditCard card) {
    _creditCards.add(card);
    notifyListeners();
  }
}
