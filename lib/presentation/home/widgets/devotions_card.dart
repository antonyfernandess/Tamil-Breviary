import 'package:flutter/material.dart';

class DevotionsCard extends StatelessWidget {
  const DevotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Devotionals',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0A2F27),
            ),
          ),
          const SizedBox(height: 14),
          const _DevotionItem(
            icon: Icons.circle_outlined,
            title: 'Rosary',
            subtitle: 'Sorrowful Mysteries',
          ),
          const Divider(height: 20, color: Color(0xFFD8D2C8)),
          const _DevotionItem(
            icon: Icons.add,
            title: 'Divine Mercy Chaplet',
          ),
          const Divider(height: 20, color: Color(0xFFD8D2C8)),
          const _DevotionItem(
            icon: Icons.favorite_border,
            title: 'Daily Reflection',
          ),
        ],
      ),
    );
  }
}

class _DevotionItem extends StatelessWidget {
  const _DevotionItem({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE3E1D9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0A2F27), width: 1.6),
          ),
          child: Icon(icon, color: const Color(0xFF0A2F27), size: 28),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A2F27),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF0A2F27).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
