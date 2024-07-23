import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:user_app/views/order_tracking_screen/constants.dart';

class OrderTrackingPage extends StatefulWidget {
  final LatLng orderLocation; // موقع الطلب
  final LatLng restaurantLocation; // موقع المطعم

  const OrderTrackingPage({
    Key? key,
    required this.orderLocation,
    required this.restaurantLocation,
  }) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  Location location = Location();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      if (currentLocation != null) {
        final GoogleMapController googleMapController =
            await _controller.future;
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 13.5,
          ),
        ));
      }
    } catch (e) {
      print('Error getting location: $e');
    }

    location.onLocationChanged.listen((newLoc) {
      if (mounted) {
        setState(() {
          currentLocation = newLoc;
        });
      }
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: google_api_key,
        request: PolylineRequest(
          origin: PointLatLng(
            widget.restaurantLocation.latitude,
            widget.restaurantLocation.longitude,
          ),
          destination: PointLatLng(
            widget.orderLocation.latitude,
            widget.orderLocation.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        if (mounted) {
          setState(() {
            polylineCoordinates.clear(); // Clear existing coordinates
            result.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
          });
        }
      } else {
        // Handle the case where no route was found
        print('No route found');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No route found')),
          );
        }
      }
    } catch (e) {
      print('Error getting route: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting route: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // إضافة إجراءات التخلص من الموارد هنا إذا لزم الأمر
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  color: primaryColor,
                  width: 6,
                  points: polylineCoordinates,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  icon:
                      BitmapDescriptor.defaultMarker, // Use default marker icon
                ),
                Marker(
                  markerId: const MarkerId("orderLocation"),
                  position: LatLng(widget.orderLocation.latitude,
                      widget.orderLocation.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueCyan),
                ),
                Marker(
                  markerId: const MarkerId("restaurantLocation"),
                  position: LatLng(widget.restaurantLocation.latitude,
                      widget.restaurantLocation.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
              },
            ),
    );
  }
}
