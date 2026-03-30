// models/adhkar_model.dart

class Dhikr {
  final int id;
  final String text;
  final int count;

  final String filename;

  Dhikr({
    required this.id,
    required this.text,
    required this.count,
    required this.filename,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'],
      text: json['text'],
      count: json['count'],
      filename: json['filename'],
    );
  }
}

class Category {
  final int id;
  final String category;

  final String filename;
  final List<Dhikr> array;

  Category({
    required this.id,
    required this.category,
    required this.filename,
    required this.array,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['array'] as List;
    List<Dhikr> arrayList = list.map((i) => Dhikr.fromJson(i)).toList();

    return Category(
      id: json['id'],
      category: json['category'],
      filename: json['filename'],
      array: arrayList,
    );
  }
}
