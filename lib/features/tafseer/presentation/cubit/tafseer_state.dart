part of 'tafseer_cubit.dart';

abstract class TafseerState extends Equatable {
  const TafseerState();

  @override
  List<Object> get props => [];
}

class TafseerInitial extends TafseerState {}

class TafseerLoading extends TafseerState {}

class TafseerLoaded extends TafseerState {}

class TafseerError extends TafseerState {
  final String message;
  const TafseerError(this.message);

  @override
  List<Object> get props => [message];
}
