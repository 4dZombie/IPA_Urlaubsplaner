import 'authority.dart';

class Role {
  //Attribute und dessen typen deklarieren
  final String? id;
  final String? name;
  final List<Authority>? authorities;

  //Konstruktor
  Role({
    this.id,
    this.name,
    this.authorities,
  });

  //Konvertiert ein Json Objekt in ein Role Objekt
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      authorities: json['authorities'],
    );
  }

  //Konvertiert ein Role Objekt in ein Json Objekt
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'authorities': authorities,
      };
}
