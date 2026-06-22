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
/// `:8090`, so this points at the *backend's* port, 8080.
///
/// ## Port runtime caveat (verified e2e 2026-06-21)
///
/// `jaspr.port: 8090` in `pubspec.yaml` is honoured only by the `jaspr serve`
/// dev server. A compiled server binary (`dart compile exe lib/main.server.dart`)
/// reads the port from the `PORT` env var (default 8080). So the deployed
/// dashboard MUST start with `PORT=8090` (Dockerfile/manifest), or it collides
/// with Serverpod on :8080. Verified: `PORT=8090 ./server` served :8090 and,
/// with the backend down, rendered the error state — not a crash, not fake data.
///
/// Named `backendClient` (not `client`) to avoid colliding with Jaspr's
/// `client` annotation when both are imported into a page.
final Client backendClient = Client('http://localhost:8080/');
