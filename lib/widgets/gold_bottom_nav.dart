import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoldNavItem {
  final IconData icon;
  final String label;
  const GoldNavItem({required this.icon, required this.label});
}

class GoldBottomNav extends StatelessWidget {
  final List<GoldNavItem> items;
  final int current;
  final ValueChanged<int> onTap;
  final Color accent;
  const GoldBottomNav({
    super.key,
    required this.items,
    required this.current,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final active = i == current;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 26,
                  color: active
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF0F172A).withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF0F172A).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
