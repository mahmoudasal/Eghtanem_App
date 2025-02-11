// presentation/cubit/tafseer_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:egtanem_application/features/tafseer/data/repositories/tafseer_repository.dart';
import 'package:egtanem_application/models/tafseer_model.dart';
import 'package:equatable/equatable.dart';

part 'tafseer_state.dart';

class TafseerCubit extends Cubit<TafseerState> {
  final TafseerRepository _repository;

  TafseerCubit(this._repository) : super(TafseerInitial()) {
    loadInterpretations();
  }

  List<Interpretation> _interpretations = [];

  Future<void> loadInterpretations() async {
    emit(TafseerLoading());
    try {
      _interpretations = await _repository.getInterpretations();
      emit(TafseerLoaded());
    } catch (e) {
      emit(TafseerError(e.toString()));
    }
  }

  List<Interpretation> getSuraInterpretations(int suraNumber) {
    return _interpretations
        .where((i) => i.sura == suraNumber && i.text.isNotEmpty)
        .toList();
  }
}
