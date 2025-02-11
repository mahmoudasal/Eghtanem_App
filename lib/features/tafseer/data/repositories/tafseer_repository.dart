// domain/repositories/tafseer_repository.dart
import 'package:egtanem_application/models/tafseer_model.dart';

abstract class TafseerRepository {
  Future<List<Interpretation>> getInterpretations();
}