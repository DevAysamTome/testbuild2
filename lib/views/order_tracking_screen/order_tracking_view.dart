import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final String restaurantName;
  final DateTime orderDate;
  final List<Map<String, dynamic>> itemsList;

  OrderTrackingScreen({
    required this.orderId,
    required this.restaurantName,
    required this.orderDate,
    required this.itemsList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // استبدلها بالإحداثيات الفعلية
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('restaurant'),
                position: LatLng(37.7749, -122.4194), // استبدلها بالإحداثيات الفعلية
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              ),
              Marker(
                markerId: MarkerId('delivery'),
                position: LatLng(37.7849, -122.4094), // استبدلها بالإحداثيات الفعلية
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: [
                  LatLng(37.7749, -122.4194), // استبدلها بالإحداثيات الفعلية
                  LatLng(37.7849, -122.4094), // استبدلها بالإحداثيات الفعلية
                ],
                color: Colors.orange,
                width: 5,
              ),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ordered At ${orderDate.toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    ...itemsList.map((item) {
                      return Text('${item['quantity']}x ${item['mealName']}');
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
