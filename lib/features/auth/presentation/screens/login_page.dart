import 'package:egtanem_application/features/auth/presentation/cubit/login_state.dart';
import 'package:egtanem_application/injection.dart';
import 'package:egtanem_application/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:egtanem_application/features/video/presentation/cubit/video_cubit.dart';
import 'package:egtanem_application/features/auth/presentation/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/login_cuibit.dart';
import 'package:logger/logger.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/custom_page_transition.dart';
import '../../../home/presentation/screens/navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final Logger _logger =
      Logger(printer: PrettyPrinter(colors: true, printEmojis: true));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.i('LoginPage dependencies changed');
    _precacheImages(context);
  }

  void _precacheImages(BuildContext context) {
    _logger.d('Starting image precaching');
    final images = [
      'assets/cards_photos/احاديث.webp',
      'assets/cards_photos/المصحف.webp',
      'assets/cards_photos/السيره النبويه.webp',
      'assets/cards_photos/عقيده.webp',
      'assets/cards_photos/الأخلاق الإسلامية.webp',
      'assets/cards_photos/الأدعية والأذكار.webp',
    ];

    for (final imagePath in images) {
      _logger.t('Precaching image: $imagePath');
      precacheImage(AssetImage(imagePath), context);
    }
    _logger.d('Image precaching completed');
  }

  void _navigateToMainScreen() {
    _logger.i('Navigating to main screen');
    Navigator.pushAndRemoveUntil(
      context,
      createRoute(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<NavigationCubit>()),
            BlocProvider(create: (context) => getIt<VideoCubit>()),
          ],
          child: const AppNavigationBar(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _logger.t('LoginPage disposed');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building LoginPage UI');
    return Scaffold(
      backgroundColor: AppColors.primary1,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          _logger.d('Login state changed: ${state.runtimeType}');
          if (state is LoginLoading) {
            _logger.i('Login process started');
            setState(() => _isLoading = true);
          } else if (state is LoginSuccess) {
            _logger.i('Login successful');
            setState(() => _isLoading = false);
            _navigateToMainScreen();
          } else if (state is LoginError) {
            _logger.e('Login failed: ${state.message}');
            setState(() => _isLoading = false);
            _showError(state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/onboarding/onboarding_login.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(160, 0, 0, 0),
                        Colors.black.withValues(alpha: 1),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              'assets/logo/logo.webp',
                              width: 0.65.sw,
                              colorBlendMode: BlendMode.plus,
                            ),
                          ),
                          Text(
                            "إغتنم",
                            style: AppTextStyles.headingsH1,
                          ),
                          SizedBox(height: 30.h),
                          _buildEmailField(),
                          SizedBox(height: 16.h),
                          _buildPasswordField(),
                          SizedBox(height: 32.h),
                          _buildLoginButton(),
                          SizedBox(height: 16.h),
                          _buildRegisterButton(),
                          SizedBox(height: 90.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showError(String message) {
    _logger.w('Showing error snackbar: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: AppTextStyles.headingsH6.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'أدخل بريدك الإلكتروني',
          hintStyle: AppTextStyles.headingsH6.copyWith(color: Colors.white54),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primary0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.3),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
          final emailRegex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          );
          return emailRegex.hasMatch(value) ? null : 'بريد إلكتروني غير صالح';
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: AppTextStyles.headingsH6.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'أدخل كلمة المرور',
          hintStyle: AppTextStyles.headingsH6.copyWith(color: Colors.white54),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primary0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.3),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        validator: (value) =>
            (value?.length ?? 0) < 8 ? '8 أحرف على الأقل' : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginCubit>().loginUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                    throw Exception('🔥 This is a test exception for Sentry!');
                  }
                },
                child: Text(
                  "تسجيل الدخول",
                  style: AppTextStyles.headingsH4,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        createRoute(
          BlocProvider(
            create: (context) => getIt<RegistrationCubit>(),
            child: const RegistrationPage(),
          ),
        ),
      ),
      child: Text(
        "ليس لديك حساب؟ إنشاء حساب جديد",
        style: AppTextStyles.headingsH6.copyWith(color: Colors.white),
      ),
    );
  }
}
