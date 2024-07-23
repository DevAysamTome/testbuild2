import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('فيشال خادوك'),
            accountEmail: Text('أحب الطعام السريع'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/profile.jpg'), // استبدل هذا بمسار صورة الملف الشخصي
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          _createDrawerItem(
              icon: Icons.person,
              text: 'المعلومات الشخصية',
              onTap: () => _onSelectItem(context, 0)),
          _createDrawerItem(
              icon: Icons.location_on,
              text: 'العناوين',
              onTap: () => _onSelectItem(context, 1)),
          _createDrawerItem(
              icon: Icons.shopping_cart,
              text: 'سلة المشتريات',
              onTap: () => _onSelectItem(context, 2)),
          _createDrawerItem(
              icon: Icons.favorite,
              text: 'المفضلة',
              onTap: () => _onSelectItem(context, 3)),
          _createDrawerItem(
              icon: Icons.notifications,
              text: 'الإشعارات',
              onTap: () => _onSelectItem(context, 4)),
          _createDrawerItem(
              icon: Icons.payment,
              text: 'طرق الدفع',
              onTap: () => _onSelectItem(context, 5)),
          _createDrawerItem(
              icon: Icons.question_answer,
              text: 'الأسئلة الشائعة',
              onTap: () => _onSelectItem(context, 6)),
          _createDrawerItem(
              icon: Icons.reviews,
              text: 'آراء المستخدمين',
              onTap: () => _onSelectItem(context, 7)),
          _createDrawerItem(
              icon: Icons.settings,
              text: 'الإعدادات',
              onTap: () => _onSelectItem(context, 8)),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'تسجيل الخروج',
              onTap: () => _onSelectItem(context, 9)),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _onSelectItem(BuildContext context, int index) {
    // يمكن إضافة التنقل إلى الصفحات المختلفة هنا بناءً على الفهرس (index)
    Navigator.pop(context); // إغلاق الـ Drawer بعد الضغط
  }
}
