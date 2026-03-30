# Production-Readiness Audit — Eghtanem (اغتنم)

> Audit conducted: March 30, 2026  
> Auditor: Staff Mobile Engineer / Principal Flutter Architect  
> Scope: Architecture · State Management · Security · Performance · QA · Observability

---

## Summary Priority Matrix

| Priority | ID | Issue | Effort |
|:--------:|:--:|-------|:------:|
| **P0** | B1 | Hardcoded credentials / bypassed auth | Medium |
| **P0** | B2 | Debug signing for release build | Low |
| **P0** | B3 | `com.example.*` application ID | Low |
| **P0** | B4 | Test server API URL hardcoded | Low |
| **P0** | B5 | No code obfuscation (R8/ProGuard) | Low |
| **P1** | B6 | Two blank feature screens shipped | Low |
| **P1** | B7 | `FlutterError.onError` outside guarded zone | Low |
| **P1** | B8 | Broken / near-zero test coverage | High |
| **P1** | B9 | No crash analytics (Crashlytics / Sentry) | Medium |
| **P2** | T1–T13 | Technical debt items | Varies |

---

## Part 1 — Critical Production Blockers

> Must be resolved before any public release.

---

### B1. Hardcoded Credentials & Bypassed Authentication

**Severity:** CRITICAL · **OWASP Mobile:** M1, M8

**Files:**
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/presentation/cubit/login_cuibit.dart`
- `lib/features/auth/presentation/screens/login_page.dart`

**Problem:**  
`AuthRepositoryImpl` contains three hardcoded plaintext credential pairs
(`admin@app.com`/`123456`, `test@example.com`/`password123`, `user@demo.com`/`demo123`).  
`LoginCubit.autoLogin()` uses them directly. `LoginPage.initState()` pre-fills the fields
and fires `autoLogin()` on every page load. The form `validator` is commented out and the
login button explicitly calls `_autoLogin()` instead of validating user input.

Anyone who decompiles the APK/IPA will find these credentials in plain text. The app
currently ships with **zero real authentication**.

**Fix — `auth_repository_impl.dart`:**

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.login(email, password);
      await SecureStorage.storeToken(response.token);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
    // ✗ NO mock fallback — if the server is down, surface an error to the user.
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.register(name, email, password);
      await SecureStorage.storeToken(response.token);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
```

**Fix — `login_cuibit.dart`:** Delete `autoLogin()` entirely.

**Fix — `login_page.dart`:**
1. Remove credential pre-fill from `initState()`.
2. Remove the `addPostFrameCallback` that fires `_autoLogin()`.
3. Uncomment the `_formKey.currentState!.validate()` guard in `_buildLoginButton()`.
4. Call `context.read<LoginCubit>().login(email: ..., password: ...)` on valid submit.

---

### B2. Release Build Signed with Debug Keys

**Severity:** CRITICAL  
**File:** `android/app/build.gradle.kts`

**Problem:**

```kotlin
release {
    // Signing with the debug keys for now
    signingConfig = signingConfigs.getByName("debug")
}
```

Google Play will **reject** this binary. More critically, anyone with the public debug
keystore can sign a trojanised APK that will be accepted as an update by existing installs.

**Fix — `android/app/build.gradle.kts`:**

```kotlin
signingConfigs {
    create("release") {
        storeFile = file(System.getenv("KEYSTORE_PATH") ?: "../keystore/release.jks")
        storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
        keyAlias   = System.getenv("KEY_ALIAS") ?: ""
        keyPassword = System.getenv("KEY_PASSWORD") ?: ""
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

Store credentials in CI/CD secrets (GitHub Actions / Codemagic). Never commit
`keystore.jks` or `key.properties` to the repository — add them to `.gitignore`.

---

### B3. Reserved `com.example.*` Application ID

**Severity:** CRITICAL  
**File:** `android/app/build.gradle.kts`

```kotlin
applicationId = "com.example.eghtanem_app"  // ← rejected by Play Store
```

Also update `ios/Runner/Info.plist`'s `CFBundleIdentifier` and the Xcode project.

**Fix:** Change to your organization's reverse-domain, e.g. `com.eghtanem.app`.

---

### B4. API Base URL Points to Test Server

**Severity:** CRITICAL  
**File:** `lib/core/constants/api_endpoints.dart`

```dart
static const baseUrl = 'https://eghtanem.testworks.top/public/api/';
```

**Fix — environment-aware configuration:**

```dart
// lib/core/config/app_config.dart
enum Env { dev, staging, production }

class AppConfig {
  static late Env environment;

  static String get baseUrl {
    switch (environment) {
      case Env.dev:
        return 'https://eghtanem.testworks.top/public/api/';
      case Env.staging:
        return 'https://staging.eghtanem.com/api/';
      case Env.production:
        return 'https://api.eghtanem.com/';
    }
  }
}
```

Initialise in `main.dart` via `--dart-define`:

```dart
// main.dart
const envName = String.fromEnvironment('ENV', defaultValue: 'dev');
AppConfig.environment = Env.values.byName(envName);
```

```bash
# CI production build
flutter build appbundle --dart-define=ENV=production
```

> **Note:** Also fix the double-slash bug (see T5): `'$baseUrl/register'` produces `.../api//register`
> because `baseUrl` already ends with `/`. Remove the leading `/` from every endpoint constant.

---

### B5. No Code Obfuscation

**Severity:** HIGH  
**File:** `android/app/build.gradle.kts`

With `isMinifyEnabled = false` (the default), all Dart identifiers, string literals, and
API endpoints are readable in the release binary via strings extraction.

**Fix:** Add to the `flutter build` command:

```bash
flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info=build/debug-info/ \
  --dart-define=ENV=production
```

Upload the `build/debug-info/` symbols to Firebase Crashlytics / Sentry so stack traces
remain human-readable in your monitoring dashboard.

---

### B6. Two Incomplete Feature Screens Ship Empty

**Severity:** HIGH  
**Files:**
- `lib/features/categories/prophetic_biography.dart`
- `lib/features/categories/prophets_stories.dart`

Both screens define 26 and 43 YouTube video URLs respectively, but `build()` returns only
an `AppBar` with no body. Users tapping these categories see a blank screen.

**Fix (choose one):**

**Option A — Implement the list view** (recommended):

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.primary1,
    appBar: _buildAppBar(context),
    body: ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return ListTile(
          title: Text(video['title']!, style: AppTextStyles.headingsH6),
          onTap: () => _launchUrl(video['url']!),
        );
      },
    ),
  );
}
```

**Option B — Hide until ready:**  
Remove the two cards from `lib/features/home/presentation/screens/categories.dart`
until the feature is complete.

---

### B7. `FlutterError.onError` Set Outside `runZonedGuarded`

**Severity:** HIGH  
**File:** `lib/main.dart`

```dart
// Current — WRONG
runZonedGuarded(() async {
  // ...
  runApp(const MyApp());
}, (error, stack) { /* ... */ });

FlutterError.onError = (details) {  // ← outside the guarded zone
  FlutterError.dumpErrorToConsole(details);
};
```

If the `onError` callback itself throws, the exception escapes to the root zone unhandled
and can crash the app.

**Fix:**

```dart
Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Set INSIDE the guarded zone
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
        AppLogger.e('Flutter framework error', details.exception, details.stack);
        // After B9 is resolved: FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      await setupDependencies();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      runApp(const MyApp());
    },
    (error, stackTrace) {
      AppLogger.e('Uncaught async error', error, stackTrace);
      // After B9: FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
}
```

---

### B8. Broken / Near-Zero Test Coverage

**Severity:** HIGH  
**Files:** `test/widget_test.dart`, `test/models/user_model_test.dart`

- `widget_test.dart` tests a counter widget that **does not exist** in this app — it will
  fail on first run.
- `user_model_test.dart` covers one model serialisation round-trip out of ~74 source files.
- No cubit tests, no repository tests, no widget tests, no integration tests.

**Fix — minimum test suite before launch:**

```
test/
├── features/
│   ├── auth/
│   │   ├── cubit/login_cubit_test.dart        ← mock AuthRepository, verify states
│   │   ├── cubit/registration_cubit_test.dart
│   │   └── repository/auth_repository_test.dart  ← mock AuthService via Mocktail
│   ├── video/
│   │   ├── cubit/video_cubit_test.dart
│   │   └── repository/video_repository_test.dart
│   ├── hadith/
│   │   └── cubit/hadith_cubit_test.dart
│   └── tafseer/
│       └── cubit/tafseer_cubit_test.dart
└── models/
    └── user_model_test.dart  ← already exists ✓
```

Add `mocktail: ^0.3.0` to `dev_dependencies`.

Example cubit test:

```dart
// test/features/auth/cubit/login_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late LoginCubit cubit;

  setUp(() {
    mockRepo = MockAuthRepository();
    cubit = LoginCubit(authRepository: mockRepo);
  });

  tearDown(() => cubit.close());

  blocTest<LoginCubit, LoginState>(
    'emits [Loading, Success] on valid login',
    build: () {
      when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => fakeAuthResponse);
      return cubit;
    },
    act: (c) => c.login(email: 'user@test.com', password: 'password'),
    expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
  );
}
```

---

### B9. No Crash Analytics

**Severity:** HIGH

Console logs (`AppLogger`) are invisible in production. There is no crash reporting
service — you will not know when the app crashes for real users.

**Fix:**

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.x.x
  firebase_crashlytics: ^4.x.x
```

```dart
// main.dart (after B7 fix is applied)
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

// In runZonedGuarded error handler:
(error, stackTrace) {
  FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
}
```

---

## Part 2 — Technical Debt

> Fix in upcoming sprints, ordered by impact.

---

### T1. Duplicate `AdhkarService` Class

**Files:**
- `lib/features/dhikr/data/models/azkar_json.dart` (lines 60–67)
- `lib/features/dhikr/data/services/adhkar_service.dart`

Two identical `AdhkarService` class definitions will cause runtime ambiguity. Remove the
one inside the model file; keep only the dedicated service file.

---

### T2. Mixed HTTP Clients (`dio` + `http`)

`lib/features/quran/data/repositories/quran_repo.dart` uses `package:http` directly,
bypassing the `AuthInterceptor`, timeout configuration, and `PrettyDioLogger`.
Standardise on `dio` across the entire network layer.

---

### T3. Unused Dependency: `provider`

`provider: ^6.1.2` is declared in `pubspec.yaml` but the app exclusively uses BLoC/Cubit.
Remove it to reduce APK size and eliminate confusion about which state management to use.

---

### T4. Naming & Organisation Issues

| Issue | File | Fix |
|-------|------|-----|
| Typo in filename | `login_cuibit.dart` | Rename to `login_cubit.dart` |
| Meaningless route constants | `routes.dart` — `pageOne`…`pageFour` | Rename to `onboarding`, `login`, `home`, etc. |
| Leftover duplicate screen | `lib/features/tafseer/data/tafseer.dart` | Delete — superseded by `tafseer_screen.dart` |

---

### T5. Double-Slash in All API Endpoint URLs

```dart
// api_endpoints.dart
static const baseUrl = 'https://.../api/';          // trailing slash
static const register = '$baseUrl/register';         // → .../api//register
```

Remove the leading `/` from every constant:

```dart
static const register = '${baseUrl}register';
static const login    = '${baseUrl}login';
// etc.
```

---

### T6. Cubits Not Registered in the DI Container

`HadithCubit`, `TafseerCubit`, and `DhikrCubit` are not registered in `injection.dart`.
All cubits should flow through `GetIt` for testability and consistent lifecycle management:

```dart
// injection.dart
getIt.registerFactory(() => HadithCubit());
getIt.registerFactory(() => TafseerCubit(getIt<TafseerRepository>()));
getIt.registerFactory(() => DhikrCubit(getIt<AdhkarService>()));
```

---

### T7. No Input Sanitisation on Comment Submission

`comment_bottom_sheet.dart` adds comments locally after a `.trim()`. If comments are
ever persisted to the backend, unsanitised HTML/script content could be submitted.
Strip or escape HTML at the client boundary before any API call.

---

### T8. Video Player Memory Pressure

Each `VideoPlayerCard` creates its own `VideoPlayerController` and resolves YouTube
streams via `youtube_explode_dart`. In a `PageView`, multiple controllers stay alive
simultaneously, accumulating native memory pressure.

**Fix — limit concurrent live controllers and cancel inflight init on dispose:**

```dart
class _VideoPlayerCardState extends State<VideoPlayerCard> {
  Future<void>? _initFuture;
  bool _cancelled = false;

  Future<void> _initializeVideo() async {
    // ... resolve URL ...
    if (_cancelled) return;        // guard after every await
    await _videoController?.initialize();
    if (_cancelled || !mounted) return;
    setState(() => _isInitialized = true);
    _videoController?..play()..setLooping(true);
  }

  @override
  void dispose() {
    _cancelled = true;
    _videoController?.dispose();
    super.dispose();
  }
}
```

For the `PageView`, consider a controller pool that keeps at most 3 initialized
controllers (previous, current, next).

---

### T9. No Pagination for Hadith List

`HadithCubit.loadAllHadiths()` loads the entire `ibn_maja.json` into memory at once.
Implement lazy pagination (page size ~50) to keep memory usage bounded as the dataset grows.

---

### T10. No Offline / Connectivity Handling

The Quran repo calls `mp3quran.net` directly with no cache and no connectivity check.
If the device is offline the listen tab fails silently.

**Recommended additions:**
- `connectivity_plus` for reactive connectivity state.
- Local cache for reciter list (store last successful response in `SharedPreferences`).
- User-facing offline banner via a global `ConnectivityCubit`.

---

### T11. No CI/CD Pipeline

There is no GitHub Actions / Fastlane / Codemagic configuration. Before production:

```yaml
# .github/workflows/ci.yml (minimal starter)
name: CI
on: [push, pull_request]
jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v4
```

---

### T12. Weak Lint Configuration

`analysis_options.yaml` uses only the base `flutter_lints` ruleset with no custom rules.

**Recommended additions:**

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    missing_return: error
    dead_code: warning
    unawaited_futures: warning
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - always_use_package_imports
    - avoid_print
    - cancel_subscriptions
    - close_sinks
    - prefer_const_constructors
    - prefer_const_declarations
    - unawaited_futures
```

---

### T13. No Android Network Security Config

Android 9+ blocks cleartext (HTTP) traffic by default. There is no
`network_security_config.xml` defined. While the current API uses HTTPS, add the
config explicitly to document your intent and avoid silent failures:

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

```xml
<!-- android/app/src/main/AndroidManifest.xml — inside <application> -->
android:networkSecurityConfig="@xml/network_security_config"
```

---

## Architecture Assessment

### What is working well ✓

- **Feature-driven folder structure** — each feature owns its `data/` and `presentation/` layers.
- **BLoC/Cubit** used consistently for state management in registered features.
- **`GetIt` service locator** wired up correctly for auth and video features.
- **`SecureStorage`** used for token persistence (correct choice over `SharedPreferences`).
- **`AuthInterceptor`** cleanly separates token injection from business logic.
- **Retrofit + Dio** for the network layer — good foundation.
- **Exception hierarchy** (`AppException` → `ServerException`, `ValidationException`, etc.) is well-structured.

### What needs architectural attention ✗

- **No `Either`/`Result` type** in repositories — errors are thrown as raw `Exception`, making
  error-path handling ad-hoc at the cubit level. Consider `fpdart` or a simple `Result<T>`.
- **Cubits not universally DI-managed** — `HadithCubit`, `TafseerCubit`, `DhikrCubit` created inline.
- **No domain layer** — repository implementations hold business logic directly. For the current
  app size this is acceptable, but plan use-cases as the feature set grows.
- **`provider` package present but unused** — indicates indecision about state management approach.
- **No route guard / auth gate** — nothing prevents a deep-link from bypassing the login screen
  once a session token exists (or no longer exists).
