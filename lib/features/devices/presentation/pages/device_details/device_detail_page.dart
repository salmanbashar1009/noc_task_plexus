import 'package:flutter/material.dart';
import '../../../domain/entities/device_entity.dart';
import 'widgets/device_info_grid.dart';
import 'widgets/performance_chart_card.dart';

class DeviceDetailPage extends StatelessWidget {
  final DeviceEntity device;

  const DeviceDetailPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          device.name,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 24),
            Text(
              "Performance Metrics",
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            PerformanceChartCard(
              title: "CPU Usage",
              value: device.cpuUsage,
              color: Colors.cyan,
            ),
            const SizedBox(height: 16),
            PerformanceChartCard(
              title: "Memory Usage",
              value: device.memoryUsage,
              color: Colors.purpleAccent,
            ),
            const SizedBox(height: 24),
            DeviceInfoGrid(device: device),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (device.isOnline ? Colors.green : Colors.red).withAlpha(
              isDark ? 26 : 128,
            ),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: device.isOnline
                  ? Colors.green.withAlpha(52)
                  : Colors.red.withAlpha(52),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.router,
              size: 32,
              color: device.isOnline ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                device.isOnline ? "Active" : "Inactive",
                style: TextStyle(
                  color:
                      device.isOnline ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
