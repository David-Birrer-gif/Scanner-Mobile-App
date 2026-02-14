import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'core/di/providers.dart';
import 'core/l10n/app_strings.dart';
import 'features/products/presentation/screens/add_edit_product_screen.dart';
import 'features/products/presentation/screens/home_screen.dart';
import 'features/products/presentation/screens/scan_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';

const _dailyReconcileTask = 'daily-reconcile-task';

@pragma('vm:entry-point')
Future<void> _backgroundCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    if (task != _dailyReconcileTask) return true;
    final container = ProviderContainer();
    await container.read(notificationServiceProvider).initialize();
    await container.read(notificationOrchestratorProvider).reconcileAll();
    container.dispose();
    return true;
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(_backgroundCallbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask(
    _dailyReconcileTask,
    _dailyReconcileTask,
    frequency: const Duration(hours: 24),
  );

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).initialize();
  await container.read(notificationOrchestratorProvider).reconcileAll();
  runApp(UncontrolledProviderScope(container: container, child: const ScannerApp()));
}

class ScannerApp extends ConsumerWidget {
  const ScannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    return MaterialApp(
      title: 'Fridge Scanner',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AppShell(),
      routes: {
        ScanScreen.route: (_) => const ScanScreen(),
        AddEditProductScreen.route: (_) => const AddEditProductScreen(),
        StatisticsScreen.route: (_) => const StatisticsScreen(),
        SettingsScreen.route: (_) => const SettingsScreen(),
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final pages = [
      const HomeScreen(),
      const ScanScreen(),
      const StatisticsScreen(),
      const SettingsScreen(),
    ];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: strings.t('home')),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            label: strings.t('scan'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            label: strings.t('stats'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: strings.t('settings'),
          ),
        ],
      ),
    );
  }
}
