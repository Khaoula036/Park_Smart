import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:park_smart/parkingliste_screen.dart'; 

class ParkingDetailsScreen extends StatefulWidget {
  final Parking parking;

  const ParkingDetailsScreen({Key? key, required this.parking}) : super(key: key);

  @override
  _ParkingDetailsScreenState createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  String userLocation = "Location not available";
  String userPostalAddress = "Address not available";
  double distanceToParking = 0.0;

  @override
  void initState() {
    super.initState();
    _initGeocoding();
    _getUserLocation();
    _calculateDistance();
  }

Future<void> _initGeocoding() async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the case where the user denied access to location
      print('User denied access to location');
      setState(() {
        userLocation = 'Location access denied';
      });
      return;
    } else if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user denied access to location permanently
      print('User denied access to location permanently');
      setState(() {
        userLocation = 'Location access denied permanently';
      });
      return;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
      widget.parking.coordinates[0],
      widget.parking.coordinates[1],
    );

    if (placemarks.isNotEmpty) {
      Placemark userPlacemark = placemarks[0];
      String userAddress = '${userPlacemark.street}, ${userPlacemark.locality}, ${userPlacemark.country}';
      
      setState(() {
        userLocation = userAddress;
      });
    } else {
      setState(() {
        userLocation = 'Location not available';
      });
    }
  } catch (e) {
    print('Error getting user location: $e');
    setState(() {
      userLocation = 'Error getting user location';
    });
  }
}


  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print('User denied access to location');
      } else if (permission == LocationPermission.deniedForever) {
        print('User denied access to location permanently');
      } else {
        Position position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        setState(() {
          userLocation = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
          userPostalAddress = placemarks.first.street ?? "Address not available";
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  Future<void> _calculateDistance() async {
    try {
      Position userPosition = await Geolocator.getCurrentPosition();
      double distance = await Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        widget.parking.coordinates[1],
        widget.parking.coordinates[0],
      );

      setState(() {
        distanceToParking = distance;
      });
    } catch (e) {
      print('Error calculating distance: $e');
    }
  }

  Future<void> _launchMapsNavigation() async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.parking.coordinates[0]},${widget.parking.coordinates[1]}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch maps navigation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Parking'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nom: ${widget.parking.name}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Adresse: ${widget.parking.address}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ville: ${widget.parking.city}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('État: ${widget.parking.state}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Disponibilité: ${widget.parking.availability} / ${widget.parking.capacity}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Dernière mise à jour: ${widget.parking.lastUpdate}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Votre position: $userLocation'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Votre adresse: $userPostalAddress'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Distance au parking: ${distanceToParking.toStringAsFixed(2)} m'),
          ),
          ElevatedButton(
            onPressed: _getUserLocation,
            child: const Text('Actualiser la position'),
          ),
          ElevatedButton(
            onPressed: _launchMapsNavigation,
            child: const Text('Naviguer vers le parking'),
          ),
        ],
      ),
    );
  }
}
