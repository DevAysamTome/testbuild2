import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final String user;
  final String comment;
  final String date;

  ReviewItem({
    required this.user,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    user[0],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              comment,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
