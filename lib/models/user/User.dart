import '../calendar/Calendar.dart';
import 'District.dart';
import 'Priority.dart';
import 'Rank.dart';
import 'Role.dart';

class User {
  //Attribute und dessen typen deklarieren
  final String id;
  final String? company;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? street;
  final String? birthdate;
  final double? holiday;
  final String? yearsOfEmployment;
  final int? age;
  final int? employment;
  final bool? kids;
  final bool? student;
  // Verschachtelte Objekte die komplexere Strukturen abbilden
  final List<Role>? roles;
  final List<Calendar>? calendars;
  final User? deputy;
  final District? district;
  final Rank? rank;
  final Priority? priority;

  //Konstruktor
  User({
    required this.id,
    this.company,
    this.firstName,
    this.lastName,
    this.email,
    this.street,
    this.birthdate,
    this.holiday,
    this.yearsOfEmployment,
    this.age,
    this.employment,
    this.kids,
    this.student,
    this.roles,
    this.calendars,
    this.deputy,
    this.district,
    this.rank,
    this.priority,
  });

  //Konvertiert ein Json Objekt in ein User Objekt
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      company: json['company'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      street: json['street'],
      birthdate: json['birthdate'],
      holiday: json['holiday'],
      yearsOfEmployment: json['yearsOfEmployment'],
      age: json['age'],
      employment: json['employment'],
      kids: json['kids'],
      student: json['student'],
      roles: json['roles'] != null
          ? List<Role>.from(json['roles'].map((role) => Role.fromJson(role)))
          : null, //Hier wird die fromJson Methode des Role Objekts aufgerufen um es in ein Role Objekt zu konvertieren, dies wird für alle Objekte in der Liste gemacht
      calendars: json['calendars'] != null
          ? List<Calendar>.from(
              json['calendars'].map((calendar) => Calendar.fromJson(calendar)))
          : null,
      deputy: json['deputy'] != null
          ? User.fromJson(json['deputy'])
          : null, //Hier wird die fromJson Methode des User Objekts aufgerufen um es in ein User Objekt zu konvertieren
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      rank: json['rank'] != null ? Rank.fromJson(json['rank']) : null,
      priority:
          json['priority'] != null ? Priority.fromJson(json['priority']) : null,
    );
  }

  //Konvertiert ein User Objekt in ein Json Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'street': street,
      'birthdate': birthdate,
      'holiday': holiday,
      'yearsOfEmployment': yearsOfEmployment,
      'age': age,
      'employment': employment,
      'kids': kids,
      'student': student,
      'roles': roles
          ?.map((role) => role.toJson())
          .toList(), //Hier wird die toJson Methode des Role Objekts aufgerufen um es in ein Json Objekt zu konvertieren, dies wird für alle Objekte in der Liste gemacht
      'calendars': calendars?.map((calendar) => calendar.toJson()).toList(),
      'deputy': deputy,
      'district': district
          ?.toJson(), //Hier wird die toJson Methode des Rank Objekts aufgerufen um es in ein Json Objekt zu konvertieren
      'rank': rank?.toJson(),
      'priority': priority?.toJson(),
    };
  }
}
