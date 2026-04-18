import 'package:flutter/material.dart';

class ServiceInfoSection extends StatelessWidget {
  const ServiceInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category + Location Row
        Row(
          children: [
            _CategoryTag(label: 'CLEANING'),
            const SizedBox(width: 10),
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Color(0xFF757575),
            ),
            const SizedBox(width: 2),
            const Text(
              'San Francisco, CA',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Title
        const Text(
          'Professional Eco-Friendly\nHome Deep Cleaning',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 12),
        // Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '\$',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '85.00',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '/ hour',
              style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String label;

  const _CategoryTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1565C0),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
