import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/device_entity.dart';

class DeviceDetailPage extends StatelessWidget {
  final DeviceEntity device;

  const DeviceDetailPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(device.name),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            const Text(
              "Performance Metrics",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            _buildChartCard("CPU Usage", device.cpuUsage, Colors.cyan),
            const SizedBox(height: 16),
            _buildChartCard(
              "Memory Usage",
              device.memoryUsage,
              Colors.purpleAccent,
            ),
            const SizedBox(height: 24),
            _buildInfoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (device.isOnline ? Colors.green : Colors.red).withOpacity(
              0.1,
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
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                device.isOnline ? "Active" : "Inactive",
                style: TextStyle(
                  color: device.isOnline
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, double value, Color color) {
    // We simulate a history graph. In a real app, you would pass a list of historic values.
    // Here we just create a dummy line based on the current value.
    final spots = List.generate(10, (i) {
      // Create some noise around the current value
      double noise = (i - 5) * 2.0;
      return FlSpot(i.toDouble(), (value + noise).clamp(0.0, 100.0));
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${value.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 9,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildInfoItem(Icons.location_on, "Location", device.location),
            const SizedBox(width: 12),
            _buildInfoItem(Icons.computer, "IP Address", device.ipAddress),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildInfoItem(
              Icons.timer,
              "Last Ping",
              DateFormat.jm().format(device.lastPingTime),
            ),
            const SizedBox(width: 12),
            _buildInfoItem(Icons.memory, "ID", device.id),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.grey, size: 18),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
