import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome,", 
          style: TextStyle(
            color: theme.brightness == Brightness.dark ? Colors.grey : Colors.grey[600], 
            fontSize: 16
          )
        ),
        const SizedBox(height: 4),
        Text(
          "Admin User",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
