import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/device_bloc.dart';
import '../../bloc/device_event.dart';
import '../../bloc/device_state.dart';
import 'widgets/device_card.dart';
import 'widgets/search_and_filter.dart';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "All Devices",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state is DeviceLoaded) {
            return Column(
              children: [
                SearchAndFilter(
                  searchQuery: state.searchQuery,
                  onSearchChanged: (val) {
                    context.read<DeviceBloc>().add(FilterDevices(searchQuery: val));
                  },
                  currentFilter: state.currentFilter,
                  onFilterChanged: (filter) {
                    context.read<DeviceBloc>().add(FilterDevices(filter: filter));
                  },
                ),
                Expanded(
                  child: state.filteredDevices.isEmpty
                      ? Center(
                          child: Text(
                            "No devices found",
                            style: TextStyle(
                              color: isDark ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<DeviceBloc>().add(RefreshDevices());
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.filteredDevices.length,
                            itemBuilder: (context, index) {
                              return DeviceCard(device: state.filteredDevices[index]);
                            },
                          ),
                        ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
