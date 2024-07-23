import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDropdown extends StatefulWidget {
  final String userId;
  final void Function(String?, LatLng?) onAddressSelected;

  AddressDropdown({required this.userId, required this.onAddressSelected});

  @override
  _AddressDropdownState createState() => _AddressDropdownState();
}

class _AddressDropdownState extends State<AddressDropdown> {
  String? _selectedAddress;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('addresses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No addresses available for this user'),
          );
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        List<Map<String, dynamic>> addresses = documents.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'address': data['address'] ?? '',
            'location': LatLng(
              double.parse(data['lat']),
              double.parse(data['lng']),
            ),
          };
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Address'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: _selectedAddress,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        var selectedAddress = addresses.firstWhere(
                          (element) => element['address'] == newValue,
                          orElse: () => {'location': LatLng(0.0, 0.0)},
                        );
                        _selectedAddress = newValue;
                        _selectedLocation = selectedAddress['location'];
                        widget.onAddressSelected(
                            _selectedAddress, _selectedLocation);
                      });
                    }
                  },
                  items: addresses.map<DropdownMenuItem<String>>((address) {
                    return DropdownMenuItem<String>(
                      value: address['address'],
                      child: Text(address['address']),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Select your address',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
