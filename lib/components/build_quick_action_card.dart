import 'package:flutter/material.dart';

Widget buildQuickActionCard(
    {required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isActive = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 93,
      height: 33,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isActive ? color : color.withOpacity(0.66),
              isActive ? color : color.withOpacity(0.45),
            ],
          ),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.black,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
