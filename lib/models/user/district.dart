class District {
  //Attribute und dessen typen deklarieren
  final String id;
  final String? name;
  final int? plz;

  //Konstruktor
  District({
    required this.id,
    this.name,
    this.plz,
  });

  //Konvertiert ein Json Objekt in ein District Objekt
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
      plz: json['plz'],
    );
  }

  //Konvertiert ein District Objekt in ein Json Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plz': plz,
    };
  }
}
