import 'package:egtanem_application/features/hadith/data/models/hadith_model.dart';

abstract class HadithState {}
class HadithInitial extends HadithState {}
class HadithLoading extends HadithState {}
class HadithLoaded extends HadithState {
  final List<Hadith> hadiths;
  final Set<int> likedHadiths;
  HadithLoaded(this.hadiths, this.likedHadiths);
}
class HadithError extends HadithState {
  final String message;
  HadithError(this.message);
}