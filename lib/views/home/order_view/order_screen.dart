import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/controller/orderController.dart';
import 'package:user_app/res/components/orederList.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'طلباتي',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.redAccent,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'الطلبات الجارية'),
              Tab(text: 'تاريخ الطلبات'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getOngoingOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ في جلب البيانات'));
                }

                List<DocumentSnapshot> ongoingOrders =
                    snapshot.data?.docs ?? [];
                return OrdersList(
                  orders: ongoingOrders,
                  isOngoing: true,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getOrderHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ في جلب البيانات'));
                }

                List<DocumentSnapshot> orderHistory = snapshot.data?.docs ?? [];
                return OrdersList(
                  orders: orderHistory,
                  isOngoing: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
