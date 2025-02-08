import 'package:egtanem_application/core/utilities/secure_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Update cache manager with auth-aware URL key
final customVideoCacheManager = CacheManager(Config(
  'authVideoCache',
  stalePeriod: const Duration(minutes: 20),
  maxNrOfCacheObjects: 10,
  fileService: AuthAwareHttpFileService(), // Custom file service
));

class AuthAwareHttpFileService extends HttpFileService {
  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) async {
    final token = await SecureStorage.getToken();
    return super.get(url, headers: {
      ...?headers,
      if (token != null) 'Authorization': 'Bearer $token',
    });
  }
}