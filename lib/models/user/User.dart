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
      roles: json['roles'],
      calendars: json['calendars'],
      deputy: json['deputy'],
      district: json['district'],
      rank: json['rank'],
      priority: json['priority'],
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
      'roles': roles,
      'calendars': calendars,
      'deputy': deputy,
      'district': district,
      'rank': rank,
    };
  }
}
