import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(3); // Default to the 'الرئيسية' page

  void changePage(int index) {
    emit(index);
  }
}
