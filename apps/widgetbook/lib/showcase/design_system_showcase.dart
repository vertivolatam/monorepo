import 'package:flutter/material.dart';
import 'package:vertivo_flutter/core/theme/app_colors.dart';
import 'package:vertivo_flutter/core/theme/app_typography.dart';

/// Showcase del Design System de Vertivo — colores y tipografía reales,
/// alimentados por style-dictionary/tokens.json vía TokenService.
class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Colores de marca', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorSwatchTile(label: 'Primary', color: AppColors.primary),
            _ColorSwatchTile(label: 'Secondary', color: AppColors.secondary),
            _ColorSwatchTile(label: 'Accent', color: AppColors.accent),
            _ColorSwatchTile(label: 'Warning', color: AppColors.warning),
            _ColorSwatchTile(label: 'Error', color: AppColors.error),
            _ColorSwatchTile(label: 'Surface', color: AppColors.surface),
          ],
        ),
        const SizedBox(height: 24),
        Text('Tipografía', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _TypographyShowcase(),
      ],
    );
  }
}

class _ColorSwatchTile extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorSwatchTile({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Text(
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _TypographyShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = AppTypography.textTheme(
      isDark: Theme.of(context).brightness == Brightness.dark,
    );
    final samples = <String, TextStyle?>{
      'Display Large': textTheme.displayLarge,
      'Headline Medium': textTheme.headlineMedium,
      'Title Large': textTheme.titleLarge,
      'Body Large': textTheme.bodyLarge,
      'Body Medium': textTheme.bodyMedium,
      'Label Small': textTheme.labelSmall,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in samples.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(entry.key, style: entry.value),
          ),
      ],
    );
  }
}
