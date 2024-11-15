import 'package:flutter/material.dart';

class EcoContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;

  const EcoContainer({
    super.key,
    required this.title,
    required this.child,
    required this.icon, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF06005A)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon), 
              const SizedBox(width: 8), 
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
