import 'package:vertivo_client/vertivo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'package:vertivolatam_ui/vertivolatam_ui.dart';
import 'screens/app_tabs.dart';
import 'screens/home_menu.dart';
import 'screens/sign_in_screen.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
late final Client client;

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize design tokens from style-dictionary/tokens.json
  await VertivoTokens.initialize();
  // When you are running the app on a physical device, you need to set the
  // server URL to the IP address of your computer. You can find the IP
  // address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
  //
  // You can set the variable when running or building your app like this:
  // E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`.
  //
  // Otherwise, the server URL is fetched from the assets/config.json file or
  // defaults to http://$localhost:8080/ if not found.
  final serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.authSessionManager.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

/// Demo mode (compile-time): `--dart-define=DEMO_MODE=true` skips the
/// sign-in gate and lands straight on the HomeMenu. The read endpoints used
/// by the demo screens (`greenhouse.getReadings`) require no session; all
/// write/user-scoped endpoints still enforce auth server-side.
/// NEVER enable in release builds.
const bool demoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hidrata el tema guardado una vez que SharedPreferences resuelve.
    ref.listen(sharedPreferencesProvider, (_, next) {
      next.whenData(
        (prefs) => ref.read(themeNotifierProvider.notifier).init(prefs),
      );
    });
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Vertivo',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      home: demoMode
          ? const Scaffold(
              body: AppTabs(),
            )
          : const MyHomePage(title: 'Vertivo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SignInScreen(child: const HomeMenu()),
    );
  }
}
