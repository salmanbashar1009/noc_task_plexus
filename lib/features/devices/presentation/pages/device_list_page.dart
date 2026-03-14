import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/device_entity.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_state.dart';
import 'device_detail_page.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  String _searchQuery = '';
  bool _filterOffline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text("All Devices"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is DeviceLoaded) {
                  // Apply filters
                  var filtered = state.devices.where((d) {
                    final matchesSearch = d.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );
                    final matchesFilter = _filterOffline ? !d.isOnline : true;
                    return matchesSearch && matchesFilter;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No devices found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      // Trigger a manual refresh event if needed
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildDeviceCard(filtered[index]);
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search device...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF16213E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => _filterOffline = !_filterOffline),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _filterOffline
                    ? Colors.redAccent
                    : const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.filter_list,
                color: _filterOffline ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(DeviceEntity device) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DeviceDetailPage(device: device)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: device.isOnline
                    ? Colors.greenAccent.withOpacity(0.1)
                    : Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.router,
                color: device.isOnline ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${device.ipAddress} • ${device.location}",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildStatusChip(device.isOnline),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOnline
            ? Colors.greenAccent.withOpacity(0.2)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOnline ? "Online" : "Offline",
        style: TextStyle(
          color: isOnline ? Colors.greenAccent : Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
