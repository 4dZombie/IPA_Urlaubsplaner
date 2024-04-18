class Rank {
  //Variablen deklarieren
  final String id;
  final String? name;

  //Konstruktor
  Rank({
    required this.id,
    this.name,
  });

  //Konvertiert ein Json Objekt in ein Rank Objekt
  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      id: json['id'],
      name: json['name'],
    );
  }
  //Konvertiert ein Rank Objekt in ein Json Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
