import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/device_entity.dart';
import 'device_info_item.dart';

class DeviceInfoGrid extends StatelessWidget {
  final DeviceEntity device;

  const DeviceInfoGrid({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DeviceInfoItem(
              icon: Icons.location_on,
              label: "Location",
              value: device.location,
            ),
            const SizedBox(width: 12),
            DeviceInfoItem(
              icon: Icons.computer,
              label: "IP Address",
              value: device.ipAddress,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            DeviceInfoItem(
              icon: Icons.timer,
              label: "Last Ping",
              value: DateFormat.jm().format(device.lastPingTime),
            ),
            const SizedBox(width: 12),
            DeviceInfoItem(
              icon: Icons.memory,
              label: "ID",
              value: device.id,
            ),
          ],
        ),
      ],
    );
  }
}
