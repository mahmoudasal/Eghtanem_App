/// Environment-aware configuration.
///
/// The active environment is selected at build time via `--dart-define`:
/// ```bash
/// flutter build appbundle --dart-define=ENV=production
/// ```
enum Env { dev, staging, production }

class AppConfig {
  AppConfig._();

  static late Env environment;

  /// Initialise from the compile-time `ENV` constant (defaults to `dev`).
  static void init() {
    const envName = String.fromEnvironment('ENV', defaultValue: 'dev');
    environment = Env.values.firstWhere(
      (e) => e.name == envName,
      orElse: () => Env.dev,
    );
  }
}
