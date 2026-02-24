import 'package:eghtanem_app/core/constants/routes.dart';
import 'package:eghtanem_app/features/auth/presentation/cubit/login_cuibit.dart';
import 'package:eghtanem_app/features/auth/presentation/screens/login_page.dart';
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
    case Routes.pageOne:
      return createRoute(const FirstPage());
    case Routes.pageTwo:
      return createRoute(const SecondPage());
    case Routes.pageThree:
      return createRoute(
        BlocProvider(
          create: (context) => getIt<LoginCubit>(),
          child: const LoginPage(),
        ),
      );
    case Routes.pageFour:
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
