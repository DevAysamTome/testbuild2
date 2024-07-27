import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CategoryCards extends StatelessWidget {
  final String title;
  final Future<List<Map<String, dynamic>>> futureData;
  final Function(Map<String, dynamic>) onTap;

  const CategoryCards({
    required this.title,
    required this.futureData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<Map<String, dynamic>> data = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Wrap ListView inside a SizedBox to control height
            SizedBox(
              height: 320, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var item = data[index];
                  return GestureDetector(
                    onTap: () => onTap(item),
                    child: Container(
                      width: 320,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12.0)),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: item['imageUrl'] != null &&
                                        item['imageUrl'].isNotEmpty
                                    ? Image.network(
                                        item['imageUrl'],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work_rounded,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "${item['openingTime']} - ${item['closingTime']}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          item['address'] ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'الحالة : ${item['status']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: item['status'] == 'مفتوح'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
