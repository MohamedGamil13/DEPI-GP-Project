import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _ReviewItem(
          name: 'Michael T.',
          rating: 5,
          comment:
              "Amazing job! My kitchen hasn't looked this good since we moved in. Very professional and arrived on time.",
        ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const _ReviewItem({
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Stars
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: i < rating
                      ? const Color(0xFFFFC107)
                      : const Color(0xFFE0E0E0),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          comment,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
