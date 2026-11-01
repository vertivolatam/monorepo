import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_provider.dart';
import '../features/monitoring/presentation/ph_monitor_screen.dart';
import '../features/telemetry/presentation/dashboard_screen.dart';
import '../features/telemetry/presentation/telemetry_screen.dart';

/// Chrome de navegación responsivo (Material 3 adaptativo):
/// - Desktop/ancho (>= 600dp): tabs en el AppBar (TabBar).
/// - Mobile/angosto: NavigationDrawer + BottomNavigationBar.
/// Orden: Sensores (dashboard) | Telemetría (canales) | pH.
class AppTabs extends ConsumerStatefulWidget {
  const AppTabs({super.key});

  @override
  ConsumerState<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends ConsumerState<AppTabs>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _index = 0;

  static const _tabs = [
    (label: 'Sensores', icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard),
    (label: 'Telemetría', icon: Icons.forum_outlined, selectedIcon: Icons.forum),
    (label: 'pH', icon: Icons.science_outlined, selectedIcon: Icons.science),
  ];

  static const _screens = [
    DashboardScreen(),
    TelemetryScreen(),
    MonitorPhScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _index != _tabController.index) {
        setState(() => _index = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _go(int i) {
    setState(() => _index = i);
    if (_tabController.index != i) _tabController.animateTo(i);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 600;
    final themeMode = ref.watch(themeModeProvider);
    final tileSize = ref.watch(tileSizeProvider);
    final bar = TabBar(
      controller: _tabController,
      onTap: _go,
      tabs: [
        for (final t in _tabs) Tab(text: t.label, icon: Icon(t.icon)),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vertivo'),
        bottom: wide ? bar : null,
        actions: [
          PopupMenuButton<TileSize>(
            icon: const Icon(Icons.grid_view_outlined),
            tooltip: 'Tamaño de tiles',
            initialValue: tileSize,
            onSelected: (s) =>
                ref.read(tileSizeProvider.notifier).state = s,
            itemBuilder: (context) => [
              for (final s in TileSize.values)
                PopupMenuItem(value: s, child: Text('Tiles: ${s.name}')),
            ],
          ),
          IconButton(
            tooltip: 'Tema claro / oscuro',
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () {
              final notifier = ref.read(themeNotifierProvider.notifier);
              notifier.setThemeMode(
                themeMode == ThemeMode.dark
                    ? AppThemeMode.light
                    : AppThemeMode.dark,
              );
            },
          ),
        ],
      ),
      drawer: wide
          ? null
          : NavigationDrawer(
              selectedIndex: _index,
              onDestinationSelected: _go,
              children: [
                const DrawerHeader(child: Text('Vertivo')),
                for (var i = 0; i < _tabs.length; i++)
                  NavigationDrawerDestination(
                    icon: Icon(_tabs[i].icon),
                    selectedIcon: Icon(_tabs[i].selectedIcon),
                    label: Text(_tabs[i].label),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(child: Text('Tiles')),
                      DropdownButton<TileSize>(
                        value: tileSize,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final s in TileSize.values)
                            DropdownMenuItem(
                              value: s,
                              child: Text(s.name.toUpperCase()),
                            ),
                        ],
                        onChanged: (s) {
                          if (s != null) {
                            ref.read(tileSizeProvider.notifier).state = s;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: _go,
              destinations: [
                for (final t in _tabs)
                  NavigationDestination(
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.selectedIcon),
                    label: t.label,
                  ),
              ],
            ),
    );
  }
}
