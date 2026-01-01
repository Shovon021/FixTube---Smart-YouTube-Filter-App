import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/theme/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  static const _themes = [
    _ThemeData('Gold', Color(0xFFF5A623), Colors.white, AppThemeMode.light),
    _ThemeData('Dark', Color(0xFFF5A623), Color(0xFF1E1E1E), AppThemeMode.dark),
    _ThemeData('Rose', Color(0xFFE91E63), Color(0xFFFCE4EC), AppThemeMode.pink),
    _ThemeData('Ocean', Color(0xFF2196F3), Color(0xFFE3F2FD), AppThemeMode.blue),
    _ThemeData('Mint', Color(0xFF4CAF50), Color(0xFFE8F5E9), AppThemeMode.green),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.palette_outlined, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Choose your preferred style',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Theme Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _themes.map((theme) {
              final isSelected = themeProvider.currentMode == theme.mode;
              return _ThemeCircle(
                theme: theme,
                isSelected: isSelected,
                onTap: () => themeProvider.setTheme(theme.mode),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ThemeData {
  final String label;
  final Color accent;
  final Color bg;
  final AppThemeMode mode;
  
  const _ThemeData(this.label, this.accent, this.bg, this.mode);
}

class _ThemeCircle extends StatelessWidget {
  final _ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCircle({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Column(
          children: [
            // Outer ring
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.accent : Colors.transparent,
                  width: 2.5,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.bg,
                  boxShadow: [
                    BoxShadow(
                      color: theme.accent.withAlpha(isSelected ? 80 : 30),
                      blurRadius: isSelected ? 12 : 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              theme.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? theme.accent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
