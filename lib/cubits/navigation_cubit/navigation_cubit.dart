import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(4); // Default to the 'الرئيسية' page

  void changePage(int index) {
    emit(index);
  }
}
