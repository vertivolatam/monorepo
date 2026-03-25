import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/dashboard_shell.dart';
import 'pages/home_page.dart';
import 'pages/greenhouses_page.dart';
import 'pages/greenhouse_detail_page.dart';
import 'pages/alerts_page.dart';
import 'pages/anomalies_page.dart';
import 'pages/users_page.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield Router(
      routes: [
        ShellRoute(
          builder: (context, state, child) => DashboardShell(child: child),
          routes: [
            Route(path: '/', builder: (_, __) => const HomePage()),
            Route(path: '/greenhouses', builder: (_, __) => const GreenhousesPage()),
            Route(
              path: '/greenhouses/:id',
              builder: (_, state) => GreenhouseDetailPage(
                greenhouseId: state.pathParameters['id'] ?? '0',
              ),
            ),
            Route(path: '/alerts', builder: (_, __) => const AlertsPage()),
            Route(path: '/anomalies', builder: (_, __) => const AnomaliesPage()),
            Route(path: '/users', builder: (_, __) => const UsersPage()),
          ],
        ),
      ],
    );
  }
}
