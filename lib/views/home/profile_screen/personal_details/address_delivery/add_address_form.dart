import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:user_app/controller/addtocartController.dart';

class AddAddressForm extends StatefulWidget {
  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
// مركز الخريطة على فلسطين
  GoogleMapController? mapController;
  loc.Location location = loc.Location();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final loc.LocationData currentLocation = await location.getLocation();
      final LatLng currentLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      setState(() {
        selectedLocation = currentLatLng;
        mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));
        _getAddressFromLatLng(currentLatLng);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'إضافة عنوان جديد',
            style: TextStyle(fontFamily: 'Elmassry'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation,
                    zoom: 14.0,
                  ),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('selected-location'),
                      position: selectedLocation,
                      draggable: true,
                      onDragEnd: (LatLng newPosition) {
                        setState(() {
                          selectedLocation = newPosition;
                          _getAddressFromLatLng(newPosition);
                        });
                      },
                    ),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'العنوان',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: streetController,
                      decoration: InputDecoration(
                        labelText: 'الشارع',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: postCodeController,
                      decoration: InputDecoration(
                        labelText: 'الرمز البريدي',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: apartmentController,
                      decoration: InputDecoration(
                        labelText: 'الشقة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: Text('منزل'),
                          selected: label == 'Home',
                          onSelected: (bool selected) {
                            setState(() {
                              label = 'Home';
                            });
                          },
                        ),
                        SizedBox(width: 8),
                        ChoiceChip(
                          label: Text('عمل'),
                          selected: label == 'Work',
                          onSelected: (bool selected) {
                            setState(() {
                              label = 'Work';
                            });
                          },
                        ),
                        SizedBox(width: 8),
                        ChoiceChip(
                          label: Text('آخر'),
                          selected: label == 'Other',
                          onSelected: (bool selected) {
                            setState(() {
                              label = 'Other';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'تحديد الموقع الحالي',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        addAddressToFirestore(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'حفظ العنوان',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          addressController.text = placemarks.first.street ?? '';
          streetController.text = placemarks.first.thoroughfare ?? '';
          postCodeController.text = placemarks.first.postalCode ?? '';
          apartmentController.text = placemarks.first.subThoroughfare ?? '';
        });
      } else {
        setState(() {
          addressController.text = '';
          streetController.text = '';
          postCodeController.text = '';
          apartmentController.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لم يتم العثور على عنوان للموقع المحدد.'),
          ),
        );
      }
    } catch (e) {
      print('Error getting address from coordinates: $e');
      setState(() {
        addressController.text = '';
        streetController.text = '';
        postCodeController.text = '';
        apartmentController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الحصول على العنوان.'),
        ),
      );
    }
  }
}
