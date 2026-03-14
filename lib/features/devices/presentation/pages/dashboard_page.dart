import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc_task_plexus/core/di/injection_container.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';
import 'device_list_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DeviceBloc>()..add(StartMonitoring()),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text("Dashboard"),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.settings, color: Colors.white70),
        //       onPressed: () {},
        //     ),
        //   ],
        // ),
        extendBodyBehindAppBar: true,
        body: BlocListener<DeviceBloc, DeviceState>(
          listener: (context, state) {
            if (state is DeviceLoaded && state.alertDevice != null) {
              // Delay alert 10s after data update
              Future.delayed(const Duration(seconds: 10), () {
                if (context.mounted) {
                  final currentState = context.read<DeviceBloc>().state;
                  if (currentState is DeviceLoaded &&
                      currentState.alertDevice != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "ALERT: ${currentState.alertDevice!.name} is offline!",
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 80,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildMetricGrid(context),
                  const SizedBox(height: 24),
                  _buildNavigationCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back,",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          "Admin User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricGrid(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state is DeviceLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyan),
            );
          }
          if (state is DeviceLoaded) {
            final online = state.devices.where((d) => d.isOnline).length;
            final offline = state.devices.where((d) => !d.isOnline).length;
            final alerts = offline; // Simplified metric

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
                  _buildMetricCard(
                    "Total Devices",
                    state.devices.length.toString(),
                    Colors.blue,
                    Icons.devices,
                  ),
                  _buildMetricCard(
                    "Online",
                    online.toString(),
                    Colors.greenAccent,
                    Icons.wifi,
                  ),
                  _buildMetricCard(
                    "Offline",
                    offline.toString(),
                    Colors.redAccent,
                    Icons.wifi_off,
                  ),
                  _buildMetricCard(
                    "Alerts",
                    alerts.toString(),
                    Colors.orangeAccent,
                    Icons.warning_amber,
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              "Unable to load data",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
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
              const Icon(Icons.more_horiz, color: Colors.grey, size: 18),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
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

  Widget _buildNavigationCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<DeviceBloc>(),
              child: const DeviceListPage(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.list_alt, color: Colors.cyan),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Device Monitor",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "View status & performance",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
