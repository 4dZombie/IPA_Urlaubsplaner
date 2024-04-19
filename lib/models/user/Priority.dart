class Priority {
  final String? id;
  final int? points;

  Priority({
    this.id,
    this.points,
  });

  factory Priority.fromJson(Map<String, dynamic> json) {
    return Priority(
      id: json['id'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points,
      };
}
