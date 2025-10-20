// navigation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTab { categories, shorts }

class NavigationCubit extends Cubit<AppTab> {
  NavigationCubit() : super(AppTab.shorts);

  void navigateTo(AppTab tab) => emit(tab);
}
