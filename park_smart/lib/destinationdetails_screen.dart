import 'package:flutter/material.dart';
import 'package:park_smart/parkingliste_screen.dart'; 


class DestinationDetailsScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailsScreen({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Destination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Adresse: ${destination.address}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Ville: ${destination.city}',
              style: TextStyle(fontSize: 18),
            ),
            // Ajoutez d'autres informations au besoin
          ],
        ),
      ),
    );
  }
}
