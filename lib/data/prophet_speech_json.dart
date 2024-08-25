class Hadith {
  final int number;
  final String hadith;
  final String description;
  final String searchTerm;

  Hadith({
    required this.number,
    required this.hadith,
    required this.description,
    required this.searchTerm,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      number: json['number'],
      hadith: json['hadith'],
      description: json['description'],
      searchTerm: json['searchTerm'],
    );
  }
}
