import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/theme/presentation/bloc/theme_bloc.dart';
import '../../bloc/device_bloc.dart';
import '../../bloc/device_event.dart';
import '../../bloc/device_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/metric_grid.dart';
import 'widgets/navigation_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<DeviceBloc>()..add(StartMonitoring()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                context.read<ThemeBloc>().add(ToggleTheme());
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: BlocListener<DeviceBloc, DeviceState>(
          listener: (context, state) {
            if (state is DeviceLoaded && state.alertDevices.isNotEmpty) {
              for (var device in state.alertDevices) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("ALERT: ${device.name} is offline!"),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                    : [const Color(0xFFF5F7FB), const Color(0xFFE8EDF5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(),
                  MetricGrid(),
                  NavigationCard(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
