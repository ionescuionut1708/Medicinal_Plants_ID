class Plant {
  final String id;
  final String scientificName;
  final String commonName;
  final String description;
  final String medicinalProperties;
  final String therapeuticUses;
  final String imagePath;
  final DateTime identifiedAt;

  Plant({
    required this.id,
    required this.scientificName,
    required this.commonName,
    required this.description,
    required this.medicinalProperties,
    required this.therapeuticUses,
    required this.imagePath,
    required this.identifiedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scientificName': scientificName,
      'commonName': commonName,
      'description': description,
      'medicinalProperties': medicinalProperties,
      'therapeuticUses': therapeuticUses,
      'imagePath': imagePath,
      'identifiedAt': identifiedAt.toIso8601String(),
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      scientificName: map['scientificName'],
      commonName: map['commonName'],
      description: map['description'],
      medicinalProperties: map['medicinalProperties'],
      therapeuticUses: map['therapeuticUses'],
      imagePath: map['imagePath'],
      identifiedAt: DateTime.parse(map['identifiedAt']),
    );
  }
}
