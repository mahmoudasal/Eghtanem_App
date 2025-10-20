// data/repositories/tafseer_repository_impl.dart
import 'dart:convert';

import 'package:eghtanem_app/features/tafseer/data/data_sources/tafseer_local_data_source.dart';
import 'package:eghtanem_app/features/tafseer/data/repositories/tafseer_repository.dart';
import 'package:eghtanem_app/features/tafseer/data/models/tafseer_model.dart';

// data/repositories/tafseer_repository_impl.dart
class TafseerRepositoryImpl implements TafseerRepository {
  final TafseerLocalDataSource _localDataSource;

  TafseerRepositoryImpl({TafseerLocalDataSource? dataSource})
      : _localDataSource = dataSource ?? TafseerLocalDataSourceImpl();

  @override
  Future<List<Interpretation>> getInterpretations() async {
    final jsonString = await _localDataSource.loadJson();
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => Interpretation.fromJson(item)).toList();
  }
}

