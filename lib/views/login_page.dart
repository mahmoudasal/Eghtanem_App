import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_page_transition.dart';
import 'register_page.dart';
import 'nav_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthResponse {
  final String token;
  final String message;

  AuthResponse({required this.token, required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      message: json['message'] ?? 'Unknown error',
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage(); // Add this line
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages(context);
  }

  void _precacheImages(BuildContext context) {
    final images = [
      'assets/احاديث.webp',
      'assets/المصحف.webp',
      'assets/السيره النبويه.webp',
      'assets/عقيده.webp',
      'assets/الأخلاق الإسلامية.webp',
      'assets/الأدعية والأذكار.webp',
    ];
    for (final imagePath in images) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

// Update the navigation method
  void _navigateToMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      createRoute(const NavigationScreen(youtubeData: {})), // Pass actual data
      (route) => false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/thirdphoto.webp',
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
                    Colors.black.withOpacity(1),
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
                      SizedBox(height: 40.h),
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/photo3.webp',
                          width: 0.65.sw,
                          colorBlendMode: BlendMode.plus,
                        ),
                      ),
                      Text(
                        "إغتنم",
                        style: AppTextSytle.headingsH1,
                      ),
                      SizedBox(height: 40.h),
                      _buildEmailField(),
                      SizedBox(height: 16.h),
                      _buildPasswordField(),
                      SizedBox(height: 32.h),
                      _buildLoginButton(),
                      SizedBox(height: 16.h),
                      _buildRegisterButton(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
        style: AppTextSytle.headingsH6.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'أدخل بريدك الإلكتروني',
          hintStyle: AppTextSytle.headingsH6.copyWith(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
          final emailRegex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
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
        style: AppTextSytle.headingsH6.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'أدخل كلمة المرور',
          hintStyle: AppTextSytle.headingsH6.copyWith(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
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
                onPressed: _navigateToMainScreen,
                child: Text(
                  'تسجيل الدخول',
                  style: AppTextSytle.headingsH3.copyWith(color: Colors.white),
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        createRoute(RegistrationPage()),
      ),
      child: Text(
        "ليس لديك حساب؟ إنشاء حساب جديد",
        style: AppTextSytle.headingsH6.copyWith(color: Colors.white),
      ),
    );
  }
}
