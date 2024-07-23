// category_card.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String icon;
  final String title;
  final Function onTap;

  const CategoryCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: 140,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.redAccent.shade200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
