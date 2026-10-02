import 'package:flutter/material.dart';

class ThisWeekCard extends StatelessWidget {
  const ThisWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sun',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E7),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0A2F27),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(days.length, (index) {
              final isDone = index < 5;
              final label = days[index];

              return Expanded(
                child: Column(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDone
                            ? const Color(0xFF0A2F27)
                            : const Color(0xFF0A2F27).withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFF6B4B8F) : const Color(0xFFCED8D3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (index < days.length - 1) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: isDone ? const Color(0xFF6B4B8F) : const Color(0xFFD5DBD7),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Oct 27',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0A2F27),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Transferable Solemnity',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A2F27),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
