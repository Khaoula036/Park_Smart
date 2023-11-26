

class Favorite {
  final String id;
  final String name;
  final double distance;
  final int availability;

  Favorite({
    required this.id,
    required this.name,
    required this.distance,
    required this.availability,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
      'availability': availability,
      // add other properties as needed
    };
  }
}
