import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final VoidCallback onTap;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
