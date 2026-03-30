import 'package:eghtanem_app/core/constants/routes.dart';
import 'package:eghtanem_app/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:eghtanem_app/features/home/presentation/screens/navigation_page.dart';
import 'package:eghtanem_app/features/video/presentation/cubit/video_cubit.dart';
import 'package:eghtanem_app/injection.dart';
import 'package:eghtanem_app/views/onboarding_one.dart';
import 'package:eghtanem_app/views/onboarding_two.dart';
import 'package:eghtanem_app/widgets/custom_page_transition.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.onboardingOne:
      return createRoute(const FirstPage());
    case Routes.onboardingTwo:
      return createRoute(const SecondPage());
    case Routes.home:
      return createRoute(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<NavigationCubit>()),
            BlocProvider(create: (_) => getIt<VideoCubit>()),
          ],
          child: const AppNavigationBar(),
        ),
      );
    default:
      return createRoute(const FirstPage());
  }
}
