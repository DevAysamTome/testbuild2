import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'),
      ),
      body: Center(
        child: Text('هذه هي صفحة الإعدادات'),
      ),
    );
  }
}
