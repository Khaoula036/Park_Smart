import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:park_smart/details_screen.dart'; 

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  ParkingScreenState createState() => ParkingScreenState();
}

class ParkingScreenState extends State<ParkingScreen> {
  List<Parking> parkings = [];
  bool isLoading = true;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchParkings();
  }
Future<void> fetchParkings() async {
  print('Fetching parkings...'); // Ajout d'un print pour marquer le début de la récupération des données
  final response = await http.get(Uri.parse('https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=20'));

  if (response.statusCode == 200) {
    final parsedData = json.decode(response.body);
    final parkingList = parsedData['results'] as List<dynamic>;

    parkings = parkingList.map((data) {
      final fields = data['properties'];
      return Parking.fromJson(fields);
    }).toList();

    setState(() {
      isLoading = false;
    });

    print('Data loaded successfully'); // Ajout d'un print pour indiquer que les données ont été chargées avec succès
  } else {
    logger.d('Réponse inattendue avec un code ${response.statusCode}');
    setState(() {
      isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Parkings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parkings.length,
              itemBuilder: (context, index) {
                final parking = parkings[index];
                return ListTile(
                  title: Text(parking.name),
                  subtitle: Text('Distance: ${parking.distance} km'),
                  trailing: Text('Disponibilité: ${parking.availability}'),
                   onTap: () {
                    // Naviguer vers l'écran de détails du parking avec parking comme argument
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingDetailsScreen(parking: parking)));
                  },
                );
              },
            ),
    );
  }
}

class Parking {
  final double id;
  final String name;
  final double distance;
  final int availability;

  Parking({
    required this.id,
    required this.name,
    required this.distance,
    required this.availability,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'] as double,
      name: json['libelle'] as String,
      distance: json['distance'] as double,
      availability: json['libre'] as int,
    );
  }
}
