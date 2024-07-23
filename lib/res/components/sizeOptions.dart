import 'package:flutter/material.dart';

class SizeOption extends StatelessWidget {
  final String size;
  final bool selected;

  SizeOption({required this.size, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selected ? Colors.orange : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(size, style: TextStyle(fontSize: 18)),
    );
  }
}