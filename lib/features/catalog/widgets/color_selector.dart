import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';

class ColorSelectorController {
  String? _selected;
  String? get selectedColor => _selected;

  final _controller = StreamController<String?>.broadcast();
  Stream<String?> get onChanged => _controller.stream;

  void select(String colorName) {
    _selected = colorName;
    _controller.add(colorName);
  }

  void dispose() => _controller.close();
}

class ColorSelector extends StatefulWidget {
  final ColorSelectorController? controller;

  const ColorSelector({super.key, this.controller});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int _selected = 0;

  static final List<_ColorEntry> _colors = [
    _ColorEntry('Navy', AppColors.navy),
    _ColorEntry('Black', AppColors.monoBlack),
    _ColorEntry('Grey', AppColors.monoGrey),
    _ColorEntry('Brown', AppColors.brass),
    _ColorEntry('White', AppColors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _colors.asMap().entries.map((entry) {
            final isSelected = entry.key == _selected;
            final color = entry.value;
            return GestureDetector(
              onTap: () {
                AppHaptics.selection();
                setState(() => _selected = entry.key);
                widget.controller?.select(color.name);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: color.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.monoBlack
                        : AppColors.monoDivider,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.color.withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorEntry {
  final String name;
  final Color color;
  const _ColorEntry(this.name, this.color);
}
