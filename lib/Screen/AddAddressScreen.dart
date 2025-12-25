import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:majorproject/utils.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ...

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: 'Location services are disabled.',
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        showAppSnackbar(
          context: context,
          type: SnackbarType.error,
          description: 'Location permissions are denied',
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description:
            'Location permissions are permanently denied, we cannot request permissions.',
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      _updateLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      debugPrint("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  void _updateLocation(LatLng position) async {
    setState(() {
      _currentPosition = position;
      _markers = {
        Marker(markerId: const MarkerId('current'), position: position),
      };
      _isLoading = false;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(position));
    }

    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _streetController.text = place.street ?? '';
          _cityController.text = place.locality ?? '';
          _stateController.text = place.administrativeArea ?? '';
          _zipController.text = place.postalCode ?? '';
          _countryController.text = place.country ?? '';
        });
      }
    } catch (e) {
      debugPrint("Error decoding address: $e");
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.phoneNumber != null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(user.phoneNumber)
            .collection('Addresses')
            .add({
              'street': _streetController.text,
              'city': _cityController.text,
              'state': _stateController.text,
              'zip': _zipController.text,
              'country': _countryController.text,
              'latitude': _currentPosition?.latitude,
              'longitude': _currentPosition?.longitude,
              'createdAt': FieldValue.serverTimestamp(),
            });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Address",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : _currentPosition == null
                  ? const Center(child: Text("Location not available"))
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      markers: _markers,
                      onTap: (pos) => _updateLocation(pos),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        labelText: "Street Address",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: "City",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: "State",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _zipController,
                            decoration: const InputDecoration(
                              labelText: "Zip Code",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _countryController,
                            decoration: const InputDecoration(
                              labelText: "Country",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _saveAddress,
                        child: const Text(
                          "Save Address",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
