import 'package:vertivo_client/vertivo_client.dart';

/// Serverpod client for the dashboard cockpit.
///
/// Mirror of `vertivo_flutter/lib/main.dart`, minus the Flutter-only bits
/// (`FlutterConnectivityMonitor`, `FlutterAuthSessionManager`) which do not
/// exist server-side.
///
/// ## SSR spike notes (open question #3 — resolved)
///
/// `vertivo_dashboard` runs `mode: server`: it has two entry points,
/// `main.server.dart` (SSR on the Dart VM) and `main.client.dart` (hydration,
/// compiled to JS in the browser). The same `App`/pages render in both.
///
/// `serverpod_client` runs on the Dart VM fine, so **fetching happens
/// server-side during SSR**, where this `Client` lives. We do NOT call the
/// backend from the hydrated browser code in this phase — that would require
/// shipping the auth session (JWT) to the client and a CORS/identity story
/// that is out of scope here. The admin session (the `Scope.admin` JWT the
/// `adminFleet` endpoint requires) is therefore held server-side.
///
/// Backend URL: Serverpod owns `:8080`; the dashboard's own Jaspr server is on
/// `:8090` (see `pubspec.yaml`), so this points at the *backend's* port, 8080.
/// Named `backendClient` (not `client`) to avoid colliding with Jaspr's
/// `client` annotation when both are imported into a page.
final Client backendClient = Client('http://localhost:8080/');
