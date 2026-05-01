import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

/// Shows the details of a recommended listing opened from a notification.
class AdDetailScreen extends StatelessWidget {
  const AdDetailScreen({super.key, required this.ad});

  final AdModel ad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text('Listing'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              ad.photos.first,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  ad.title,
                  style: AppStyles.font17Bold.copyWith(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'EGP ${ad.price.toStringAsFixed(0)}',
                style: AppStyles.font17Bold.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaBadge(icon: ad.category.icon, label: ad.category.label),
              _MetaBadge(icon: Icons.location_on_outlined, label: ad.city),
            ],
          ),
          if (ad.relevantSkills != null && ad.relevantSkills!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ad.relevantSkills!
                  .map(
                    (skill) => _MetaBadge(
                      icon: Icons.sell_outlined,
                      label: skill.name.toUpperCase(),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 18),
          const Text('About this listing', style: AppStyles.font14w600),
          const SizedBox(height: 8),
          Text(
            ad.description,
            style: AppStyles.font14Regular.copyWith(
              color: AppColors.textMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMedium),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppStyles.font13w500.copyWith(color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}
