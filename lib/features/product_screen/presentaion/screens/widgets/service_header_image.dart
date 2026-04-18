import 'package:flutter/material.dart';

class ServiceHeaderImage extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;

  const ServiceHeaderImage({
    super.key,
    this.onBack,
    this.onShare,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          // Image
          Positioned.fill(
            child: Container(
              color: const Color(0xFF4DB6AC),
              child: Image.network(
                'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF4DB6AC),
                  child: const Icon(
                    Icons.cleaning_services_rounded,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
          // Top overlay buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  Row(
                    children: [
                      _CircleButton(icon: Icons.share_outlined, onTap: onShare),
                      const SizedBox(width: 8),
                      _CircleButton(
                        icon: Icons.favorite_border_rounded,
                        onTap: onFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF424242)),
      ),
    );
  }
}
