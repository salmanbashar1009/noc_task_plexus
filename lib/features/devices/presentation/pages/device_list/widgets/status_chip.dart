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
            ? Colors.greenAccent.withAlpha(52)
            : Colors.grey.withAlpha(52),
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
