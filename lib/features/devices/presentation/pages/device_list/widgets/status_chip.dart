import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final bool isOnline;

  const StatusChip({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
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
