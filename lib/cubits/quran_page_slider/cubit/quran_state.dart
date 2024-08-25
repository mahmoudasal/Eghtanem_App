import 'package:equatable/equatable.dart';

abstract class SurahPageState extends Equatable {
  const SurahPageState();

  @override
  List<Object?> get props => [];
}

class SurahPageInitial extends SurahPageState {}

class SurahPageLoaded extends SurahPageState {
  final int currentPage;

  const SurahPageLoaded(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}

class SurahPageError extends SurahPageState {
  final String errorMessage;

  const SurahPageError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
