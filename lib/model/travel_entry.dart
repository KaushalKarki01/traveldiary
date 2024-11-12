class TravelEntry {
  final int? id;
  final String title;
  final String desc;
  final String? img;
  TravelEntry({this.id, required this.title, required this.desc, this.img});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'desc': desc,
      'img': img,
    };
  }

  static TravelEntry fromMap(Map<String, dynamic> map) {
    return TravelEntry(
        id: map['id'], title: map['title'], desc: map['desc'], img: map['img']);
  }
}
