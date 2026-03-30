import 'package:get_it/get_it.dart';

import 'package:eghtanem_app/features/dhikr/data/services/adhkar_service.dart';
import 'package:eghtanem_app/features/dhikr/presentation/cubit/dhikr_cubit.dart';
import 'package:eghtanem_app/features/hadith/presentation/cubit/hadith_cubit.dart';
import 'package:eghtanem_app/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:eghtanem_app/features/tafseer/data/repositories/tafseer_repository.dart';
import 'package:eghtanem_app/features/tafseer/data/repositories/tafseer_repository_impl.dart';
import 'package:eghtanem_app/features/tafseer/presentation/cubit/tafseer_cubit.dart';
import 'package:eghtanem_app/features/video/data/repositories/video_repository.dart';
import 'package:eghtanem_app/features/video/data/repositories/video_repository_impl.dart';
import 'package:eghtanem_app/features/video/presentation/cubit/video_cubit.dart';

final GetIt getIt = GetIt.instance;

setupDependencies() {
  // Services
  getIt.registerSingleton<AdhkarService>(AdhkarService());

  // Repositories
  getIt.registerSingleton<VideoRepository>(VideoRepositoryImpl());
  getIt.registerSingleton<TafseerRepository>(TafseerRepositoryImpl());

  // Cubits
  getIt.registerFactory(() => VideoCubit(getIt<VideoRepository>()));
  getIt.registerFactory(() => NavigationCubit());
  getIt.registerFactory(() => HadithCubit());
  getIt.registerFactory(() => TafseerCubit(getIt<TafseerRepository>()));
  getIt.registerFactory(() => DhikrCubit(getIt<AdhkarService>()));
}
