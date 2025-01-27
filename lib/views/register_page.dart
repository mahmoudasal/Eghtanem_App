import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_page_transition.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
  });

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _formControllers = _FormControllers();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _formControllers.dispose();
    super.dispose();
  }

  // void _addRequestHeaders(http.MultipartRequest request, Request endpoint) {
  //   // Add standard headers
  //   request.headers.addAll({
  //     'Accept': 'application/json',
  //     'Content-Type': 'multipart/form-data',
  //   });

  //   // Add headers from Postman collection
  //   if (endpoint.headers != null) {
  //     for (final header in endpoint.headers!) {
  //       request.headers[header.key] = header.value;
  //     }
  //   }
  // }

  // void _addFormData(http.MultipartRequest request, List<FormData>? formdata) {
  //   // Add form data from controller values
  //   request.fields.addAll({
  //     'name': _formControllers.name.text,
  //     'email': _formControllers.email.text,
  //     'password': _formControllers.password.text,
  //   });

  //   // Add additional fields from Postman collection template
  //   if (formdata != null) {
  //     for (final field in formdata) {
  //       if (!request.fields.containsKey(field.key)) {
  //         request.fields[field.key] = field.value;
  //       }
  //     }
  //   }
  // }

  // void _addAuthentication(http.MultipartRequest request, Auth? auth) {
  //   if (auth?.type == 'bearer' && auth?.bearer != null) {
  //     final token = auth!.bearer!
  //         .firstWhere((b) => b.key == 'token',
  //             orElse: () => AuthBearer(key: 'token', value: '', type: 'string'))
  //         .value;

  //     if (token.isNotEmpty) {
  //       request.headers['Authorization'] = 'Bearer $token';
  //     }
  //   }
  // }

  void _handleRegistrationResponse(int statusCode, String responseBody) {
    try {
      final responseJson = jsonDecode(responseBody);

      if (statusCode == 201 || statusCode == 200) {
        _showSuccessMessage();
        _navigateAfterDelay();
      } else {
        final errorMessage = responseJson['message'] ??
            responseJson['error'] ??
            'فشل التسجيل (رمز الخطأ: $statusCode)';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('فشل معالجة استجابة الخادم: ${e.toString()}');
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'تم انشاء الحساب بنجاح الرجاء التوجه لتسجيل الدخول',
                style: AppTextSytle.headingsH6.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildGradientOverlay(),
          _buildRegistrationForm(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'إنشاء حساب جديد',
        style: AppTextSytle.headingsH4.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/thirdphoto.webp',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Positioned.fill(
      child: FutureBuilder<Positioned>(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('خطأ في تحميل الإعدادات: ${snapshot.error}'));
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16.w,
              right: 16.w,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
                    _buildNameField(),
                    SizedBox(height: 16.h),
                    _buildEmailField(),
                    SizedBox(height: 16.h),
                    _buildPasswordField(),
                    SizedBox(height: 32.h),
                    _buildSubmitButton(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return _buildFormField(
      controller: _formControllers.name,
      hintText: 'أدخل اسمك الكامل',
      autofillHints: const [AutofillHints.name],
      validator: Validators.validateName,
    );
  }

  Widget _buildEmailField() {
    return _buildFormField(
      controller: _formControllers.email,
      hintText: 'أدخل بريدك الإلكتروني',
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: Validators.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _formControllers.password,
      obscureText: _obscurePassword,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      autofillHints: const [AutofillHints.newPassword],
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
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: Validators.validatePassword,
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<String>? autofillHints,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      autofillHints: autofillHints,
      style: AppTextSytle.headingsH6.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
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
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: 0.9.sw,
      height: 50.h,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: null,
              child: Text(
                'تسجيل',
                style: AppTextSytle.headingsH3.copyWith(color: Colors.white),
              ),
            ),
    );
  }
}

class _FormControllers {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
  }

  Map<String, String> toJson() => {
        'name': name.text,
        'email': email.text,
        'password': password.text,
      };
}

class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'الاسم مطلوب';
    final nameRegex = RegExp(
      r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)",
    );
    return nameRegex.hasMatch(value) ? null : 'اسم غير صحيح (الإنجليزية فقط)';
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegex.hasMatch(value) ? null : 'بريد إلكتروني غير صالح';
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    return value.length < 8 ? '8 أحرف على الأقل' : null;
  }
}
