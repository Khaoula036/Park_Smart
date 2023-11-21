import 'package:flutter/material.dart';
import 'package:park_smart/database/database_helper.dart'; // Importer le gestionnaire de base de données SQLite
import 'package:park_smart/models/favorite.dart'; // Importer le modèle pour les favoris
import 'package:park_smart/liste_screen.dart'; 


class ParkingDetailsScreen extends StatefulWidget {
  final Parking parking;

  const ParkingDetailsScreen({super.key, required this.parking});

  @override
  _ParkingDetailsScreenState createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  late bool isFavorite;
  late bool isPreferred;

  @override
  void initState() {
    super.initState();
    // Vérifier si le parking est déjà dans les favoris et les destinations préférées
    checkFavoriteStatus();
    checkPreferredStatus();
  }

  void checkFavoriteStatus() async {
    // Utiliser votre gestionnaire de base de données pour vérifier si le parking est dans les favoris
    bool isFavoriteParking = await DatabaseHelper.instance.isFavorite(widget.parking.id);
    setState(() {
      isFavorite = isFavoriteParking;
    });
  }

  void checkPreferredStatus() async {
    // Utiliser votre gestionnaire de base de données pour vérifier si le parking est une destination préférée
    bool isPreferredParking = await DatabaseHelper.instance.isPreferred(widget.parking.id);
    setState(() {
      isPreferred = isPreferredParking;
    });
  }

  void toggleFavorite() async {
    // Ajouter ou supprimer le parking des favoris
    if (isFavorite) {
      await DatabaseHelper.instance.removeFavorite(widget.parking.id);
    } else {
      Favorite favorite = Favorite(
        name: widget.parking.name,
        //id: widget.parking.id,
        distance: widget.parking.distance,
        availability: widget.parking.availability,
      );
      await DatabaseHelper.instance.addFavorite(favorite);
    }

    // Mettre à jour l'état
    checkFavoriteStatus();
  }

  void togglePreferred() async {
    // Ajouter ou supprimer le parking des destinations préférées
    if (isPreferred) {
      await DatabaseHelper.instance.removePreferred(widget.parking.id);
    } else {
      // Ajouter le code pour ajouter le parking comme destination préférée
    }

    // Mettre à jour l'état
    checkPreferredStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Parking'),
      ),
      body: Column(
        children: [
          // Afficher les informations détaillées sur le parking ici

          // Ajouter un bouton pour ajouter/retirer des favoris
          ElevatedButton(
            onPressed: toggleFavorite,
            child: Text(isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'),
          ),

          // Ajouter un bouton pour ajouter/retirer des destinations préférées
          ElevatedButton(
            onPressed: togglePreferred,
            child: Text(isPreferred ? 'Retirer des destinations préférées' : 'Définir comme destination préférée'),
          ),
        ],
      ),
    );
  }
}
