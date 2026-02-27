import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final bool obscure;
  final bool showToggle;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.obscure = false,
    this.showToggle = false,
    this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(widget.prefixIcon, size: 18, color: AppColors.textLight),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              cursorColor: Colors.blue,
              controller: widget.controller,
              obscureText: _obscure,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (widget.showToggle) ...[
            GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }
}
