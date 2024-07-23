import 'package:flutter/material.dart';
import 'package:user_app/res/components/reviewItem.dart';

class ReviewsScreen extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {
      'user': 'محمد أحمد',
      'comment': 'تجربة رائعة! المنتج كان ممتاز وخدمة العملاء كانت ممتازة.',
      'date': '20 يناير 2023',
    },
    {
      'user': 'سارة علي',
      'comment': 'جودة المنتج جيدة لكن واجهت بعض المشاكل في التوصيل.',
      'date': '15 فبراير 2023',
    },
    // أضف المزيد من الآراء هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'آراء المستخدمين',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // تنفيذ عند الضغط على زر الرجوع
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: reviews.isEmpty
            ? Center(
                child: Text(
                  'لا توجد آراء حتى الآن',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return ReviewItem(
                    user: reviews[index]['user']!,
                    comment: reviews[index]['comment']!,
                    date: reviews[index]['date']!,
                  );
                },
              ),
      ),
    );
  }
}

