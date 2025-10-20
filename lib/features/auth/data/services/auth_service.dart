import 'package:dio/dio.dart';
import 'package:eghtanem_app/features/auth/data/services/auth_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @POST("register")
  @FormUrlEncoded()
  Future<AuthResponse> register(
    @Field('name') String name,
    @Field('email') String email,
    @Field('password') String password,
  );

  @POST("login")
  @FormUrlEncoded()
  Future<AuthResponse> login(
    @Field('email') String email,
    @Field('password') String password,
  );
}
