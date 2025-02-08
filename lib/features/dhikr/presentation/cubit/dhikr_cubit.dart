// dhikr_cubit.dart
import 'package:egtanem_application/features/dhikr/data/models/azkar_json.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class DhikrState {}
class DhikrInitial extends DhikrState {}
class DhikrLoading extends DhikrState {}
class DhikrLoaded extends DhikrState {
  final List<Category> categories;
  DhikrLoaded(this.categories);
}
class DhikrError extends DhikrState {
  final String message;
  DhikrError(this.message);
}

class DhikrCubit extends Cubit<DhikrState> {
  final AdhkarService _adhkarService;

  DhikrCubit(this._adhkarService) : super(DhikrInitial());

  Future<void> loadAdhkar() async {
    emit(DhikrLoading());
    try {
      final categories = await _adhkarService.loadAdhkar();
      emit(DhikrLoaded(categories));
    } catch (e) {
      emit(DhikrError(e.toString()));
    }
  }
}