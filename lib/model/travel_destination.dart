import 'dart:convert';

class TravelDestination {
  final int? id;
  final String title;
  final String desc;
  final List<String>? mediaPaths;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TravelDestination(
      {this.id,
      required this.title,
      required this.desc,
      this.mediaPaths,
      required this.createdAt,
      required this.updatedAt});

  //convert travelEntry object to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      // 'mediaPaths': mediaPaths,
      'mediaPaths': mediaPaths != null ? jsonEncode(mediaPaths) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  //create a travelEntry object from the map
  static TravelDestination fromMap(Map<String, dynamic> map) {
    return TravelDestination(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      // mediaPaths: map['mediaPaths'],
      mediaPaths: map['mediaPaths'] != null
          ? List<String>.from(jsonDecode(map['mediaPaths']))
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  //method to copy and update TravelDestination
  TravelDestination copyWith({
    int? id,
    String? title,
    String? desc,
    List<String>? mediaPaths,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TravelDestination(
        id: id ?? this.id,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        mediaPaths: mediaPaths ?? this.mediaPaths,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }
}
