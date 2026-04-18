import 'package:flutter/material.dart';

class ServiceDescriptionSection extends StatelessWidget {
  const ServiceDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Description',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Get your home sparkling clean with our professional deep cleaning service. '
          'We use only eco-friendly, non-toxic products safe for pets and children. '
          'Our service includes detailed dusting, floor sanitization, bathroom scrubbing, '
          'and kitchen deep-clean.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        const _FeatureItem(text: 'All equipment provided'),
        const SizedBox(height: 8),
        const _FeatureItem(text: 'Insured and bonded professionals'),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 18,
          color: Color(0xFF1565C0),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF424242),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
