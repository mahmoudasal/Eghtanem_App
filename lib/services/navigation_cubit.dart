import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(1); // Default to the 'الرئيسية' page

  void changePage(int index) {
    emit(index);
  }
}
