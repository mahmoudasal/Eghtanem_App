import 'package:flutter/services.dart';

abstract class TafseerLocalDataSource {
  Future<String> loadJson();
}

class TafseerLocalDataSourceImpl implements TafseerLocalDataSource {
  @override
  Future<String> loadJson() async {
    return await rootBundle.loadString('assets/quran_metadata/ar_ma3any.json');
  }
}
