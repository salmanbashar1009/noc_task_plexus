import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc_task_plexus/features/devices/presentation/pages/dashboard_page.dart';
import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/presentation/bloc/theme_bloc.dart';
import 'features/devices/presentation/bloc/device_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const PlexusApp());
}

class PlexusApp extends StatelessWidget {
  const PlexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeBloc>()..add(LoadTheme()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeMode mode = ThemeMode.dark;
          if (state is ThemeLoaded) {
            mode = state.themeMode;
          }

          return MaterialApp(
            title: 'Plexus NOC',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: LoginPage(),
            routes: {
              '/login': (context) => LoginPage(),
              '/dashboard': (context) => BlocProvider<DeviceBloc>(
                create: (_) => sl<DeviceBloc>(),
                child: const DashboardPage(),
              ),
            },
          );
        },
      ),
    );
  }
}
