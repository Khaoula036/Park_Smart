import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:park_smart/parkingdetails_screen.dart';
import 'package:park_smart/destinationdetails_screen.dart';

class ParkingListScreen extends StatefulWidget {
  const ParkingListScreen({Key? key}) : super(key: key);

  @override
  _ParkingListScreenState createState() => _ParkingListScreenState();
}

class _ParkingListScreenState extends State<ParkingListScreen> {
  List<Parking> parkings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParkings();
  }

  Future<void> fetchParkings() async {
    final response = await http.get(Uri.parse(
        'https://opendata.lillemetropole.fr/api/explore/v2.1/catalog/datasets/disponibilite-parkings/records?limit=20'));

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      final parkingList = parsedData['results'] as List<dynamic>;

      parkings = parkingList.map((data) {
        return Parking.fromJson(data);
      }).toList();

      setState(() {
        isLoading = false;
      });
    } else {
      print('Erreur de chargement des parkings');
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      if (filters.containsKey('disponibilite')) {
        double maxDisponibilite = filters['disponibilite'];
        parkings = parkings.where((parking) => parking.availability <= maxDisponibilite).toList();
      }
      print('Filtres appliqués: $filters');
    });
  }

  void _openFilterDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const FilterDialog(),
    );

    if (result != null) {
      _applyFilters(result);
    }
  }

  void _toggleFavorite(Parking parking) {
    setState(() {
      if (FavoritesManager.isFavorite(parking)) {
        FavoritesManager.removeFromFavorites(parking);
      } else {
        FavoritesManager.addToFavorites(parking);
      }
    });
  }

  void _toggleFavoriteDestination(Destination destination) {
  setState(() {
    if (DestinationsManager.isFavorite(destination)) {
      DestinationsManager.removeFromFavorites(destination);
    } else {
      DestinationsManager.addToFavorites(destination);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Parkings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: parkings.length,
              itemBuilder: (context, index) {
                final parking = parkings[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParkingDetailsScreen(parking: parking),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            parking.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Disponibilité: ${parking.availability} / ${parking.capacity}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Dernière mise à jour: ${parking.lastUpdate}'),
                        ),
                        IconButton(
                        icon: FavoritesManager.isFavorite(parking)
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_border),
                        onPressed: () {
                          _toggleFavorite(parking);
                        },
                      ),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Destinations',
          ),
        ],
        onTap: (index) {
            if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteDestinationsScreen()),
            );
          }
        },
      ),
    );
  }
}
  

class FavoritesManager {
  static List<Parking> favoriteParkings = [];

  static bool isFavorite(Parking parking) {
    return favoriteParkings.contains(parking);
  }

  static void addToFavorites(Parking parking) {
    if (!isFavorite(parking)) {
      favoriteParkings.add(parking);
    }
  }

    static void removeFromFavorites(Parking parking) {
    favoriteParkings.remove(parking);
  }
}


class DestinationsManager {
  static List<Destination> favoriteDestinations = [];

  static bool isFavorite(Destination destination) {
    return favoriteDestinations.contains(destination);
  }

  static void addToFavorites(Destination destination) {
    if (!isFavorite(destination)) {
      favoriteDestinations.add(destination);
    }
  }

  static void removeFromFavorites(Destination destination) {
    favoriteDestinations.remove(destination);
  }
}



 
class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int disponibilite = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtres'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Disponibilité: ${disponibilite.toStringAsFixed(2)}'),
          Slider(
            value: disponibilite.toDouble(),
            min: 0,
            max: 2000,
            onChanged: (value) {
              setState(() {
                disponibilite = value.round();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, {'Disponibilite': disponibilite.round()});
          },
          child: const Text('Appliquer'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

class Destination {
  final String name;
  final String address;
  final String city;
  // Ajouter d'autres propriétés au besoin

  Destination({
    required this.name,
    required this.address,
    required this.city,
    // Initialiser d'autres propriétés
  });
}


class Parking {
  final String name;
  final String address;
  final String city;
  final String state;
  final int availability;
  final int capacity;
  final DateTime lastUpdate;
  final String id;
  final List<double> coordinates;

  Parking({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.availability,
    required this.capacity,
    required this.lastUpdate,
    required this.id,
    required this.coordinates,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry']['geometry'];
    final coordinates = List<double>.from(geometry['coordinates']);
    return Parking(
      name: json['libelle'] as String,
      address: json['adresse'] as String,
      city: json['ville'] as String,
      state: json['etat'] as String,
      availability: json['dispo'] as int,
      capacity: json['max'] as int,
      lastUpdate: DateTime.parse(json['datemaj'] as String),
      id: json['id'] as String,
      coordinates: coordinates,
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: ListView.builder(
        itemCount: FavoritesManager.favoriteParkings.length,
        itemBuilder: (context, index) {
          final parking = FavoritesManager.favoriteParkings[index];
          return ListTile(
            title: Text(parking.name),
            subtitle: Text('Disponibilité: ${parking.availability} / ${parking.capacity}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParkingDetailsScreen(parking: parking),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteDestinationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destinations Préférées'),
      ),
      body: ListView.builder(
        itemCount: DestinationsManager.favoriteDestinations.length,
        itemBuilder: (context, index) {
          final destination = DestinationsManager.favoriteDestinations[index];
          return ListTile(
            title: Text(destination.name),
            subtitle: Text('Adresse: ${destination.address}, Ville: ${destination.city}'),
            onTap: () {
              // Naviguer vers l'écran de détails de la destination avec la destination sélectionnée
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DestinationDetailsScreen(destination: destination),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
