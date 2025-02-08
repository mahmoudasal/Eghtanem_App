import 'package:dio/dio.dart';
import 'package:egtanem_application/core/constants/api_endpoints.dart';
import 'package:egtanem_application/features/auth/data/services/auth_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @POST(ApiEndpoints.register)
  @FormUrlEncoded()
  Future<AuthResponse> register(
    @Field('name') String name,
    @Field('email') String email,
    @Field('password') String password,
  );

  @POST(ApiEndpoints.login)
  @FormUrlEncoded()
  Future<AuthResponse> login(
    @Field('email') String email,
    @Field('password') String password,
  );
}
