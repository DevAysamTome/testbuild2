import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  address,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
