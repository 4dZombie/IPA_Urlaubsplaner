class User {
  //Variablen deklarieren
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

  //TODO: Sobald Models verfügbar sind: Kalender,District,Rank,Role,Priority und Deputy einfügen
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
    };
  }
}
