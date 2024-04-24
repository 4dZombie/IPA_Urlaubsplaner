class Calendar {
  //Attribute und dessen typen deklarieren
  final String id;
  final String title;
  final String startDate;
  final String endDate;
  final String? status;
  final String? createdAt;
  final String? userName;
  final String? priority;
  final String? userId;

  //Konstruktor
  Calendar({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.status,
    this.createdAt,
    this.userName,
    this.priority,
    this.userId,
  });

  //Konvertiert ein Json Objekt in ein Calendar Objekt
  factory Calendar.fromJson(Map<String?, dynamic> json) {
    return Calendar(
      id: json['id'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'],
      createdAt: json['createdAt'],
      userName: json['userName'],
      priority: json['priority'],
      userId: json['userId'],
    );
  }

  //Konvertiert ein Calendar Objekt in ein Json Objekt
  Map<String?, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'createdAt': createdAt,
      'userName': userName,
      'priority': priority,
      'userId': userId,
    };
  }
}
