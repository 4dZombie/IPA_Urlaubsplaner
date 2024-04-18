class Authority {
  //Attribute und dessen typen deklarieren
  final String id;
  final String? name;

  //Konstruktor
  Authority({
    required this.id,
    this.name,
  });

  //Konvertiert ein Json Objekt in ein Authority Objekt
  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      id: json['id'],
      name: json['name'],
    );
  }
  //Konvertiert ein Authority Objekt in ein Json Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
