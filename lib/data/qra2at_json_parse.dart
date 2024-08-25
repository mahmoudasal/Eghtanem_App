class Reciter {
  final int id;
  final String name;
  final String serverUrl;

  Reciter({required this.id, required this.name, required this.serverUrl});

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'],
      name: json['name'],
      serverUrl: json['moshaf'][0]
          ['server'], // Assuming first moshaf is the desired one
    );
  }
}

class Moshaf {
  final int id;
  final String name;
  final String server;
  final int surahTotal;
  final int moshafType;
  final String surahList;

  Moshaf({
    required this.id,
    required this.name,
    required this.server,
    required this.surahTotal,
    required this.moshafType,
    required this.surahList,
  });

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      surahTotal: json['surah_total'],
      moshafType: json['moshaf_type'],
      surahList: json['surah_list'],
    );
  }
}
