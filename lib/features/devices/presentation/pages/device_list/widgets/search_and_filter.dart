import 'package:flutter/material.dart';
import '../../../bloc/device_event.dart';
import '../device_list_page.dart';

class SearchAndFilter extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final DeviceFilter currentFilter;
  final ValueChanged<DeviceFilter> onFilterChanged;

  const SearchAndFilter({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: "Search device...",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: isDark
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: isDark
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey[300]!),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<DeviceFilter>(
            onSelected: onFilterChanged,
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<DeviceFilter>>[
                  const PopupMenuItem<DeviceFilter>(
                    value: DeviceFilter.all,
                    child: Text('All Devices'),
                  ),
                  const PopupMenuItem<DeviceFilter>(
                    value: DeviceFilter.online,
                    child: Text('Online Devices'),
                  ),
                  const PopupMenuItem<DeviceFilter>(
                    value: DeviceFilter.offline,
                    child: Text('Offline Devices'),
                  ),
                ],
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentFilter != DeviceFilter.all
                    ? (currentFilter == DeviceFilter.online
                          ? Colors.greenAccent.withOpacity(0.8)
                          : Colors.redAccent)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: isDark
                    ? null
                    : Border.all(
                        color: currentFilter != DeviceFilter.all
                            ? (currentFilter == DeviceFilter.online
                                  ? Colors.greenAccent
                                  : Colors.redAccent)
                            : Colors.grey[300]!,
                      ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha(128),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                Icons.filter_list,
                color: currentFilter != DeviceFilter.all
                    ? Colors.white
                    : (isDark ? Colors.grey[600] : Colors.grey[500]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
