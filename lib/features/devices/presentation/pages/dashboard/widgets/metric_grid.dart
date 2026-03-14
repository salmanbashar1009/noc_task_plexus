import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/device_bloc.dart';
import '../../../bloc/device_event.dart';
import '../../../bloc/device_state.dart';

class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state is DeviceLoading) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            );
          }
          if (state is DeviceLoaded) {
            final online = state.devices.where((d) => d.isOnline).length;
            final offline = state.devices.where((d) => !d.isOnline).length;
            final alerts = offline;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DeviceBloc>().add(RefreshDevices());
              },
              child: GridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _MetricCard(
                    title: "Total Devices",
                    value: state.devices.length.toString(),
                    color: Colors.blue,
                    icon: Icons.devices,
                  ),
                  _MetricCard(
                    title: "Online",
                    value: online.toString(),
                    color: Colors.greenAccent,
                    icon: Icons.wifi,
                  ),
                  _MetricCard(
                    title: "Offline",
                    value: offline.toString(),
                    color: Colors.redAccent,
                    icon: Icons.wifi_off,
                  ),
                  _MetricCard(
                    title: "Alerts",
                    value: alerts.toString(),
                    color: Colors.orangeAccent,
                    icon: Icons.warning_amber,
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              "Unable to load data",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? color.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Icon(Icons.more_horiz,
                  color: isDark ? Colors.grey : Colors.grey[400], size: 18),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDark ? color : color.withOpacity(0.8),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
