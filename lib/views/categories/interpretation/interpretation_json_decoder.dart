class Interpretation {
  final int sura;
  final int aya;
  final String text;

  Interpretation({required this.sura, required this.aya, required this.text});

  factory Interpretation.fromJson(Map<String, dynamic> json) {
    return Interpretation(
      sura: json['sura'],
      aya: json['aya'],
      text: json['text'].replaceAll('<br>', '\n'), // Replace <br> with newline
    );
  }
}
