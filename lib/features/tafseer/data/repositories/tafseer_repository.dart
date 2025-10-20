// data/repositories/tafseer_repository.dart
import '../models/tafseer_model.dart';

abstract class TafseerRepository {
  Future<List<Interpretation>> getInterpretations();
}
