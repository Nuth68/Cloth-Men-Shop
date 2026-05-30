import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({super.key});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int _selected = 0;
  final List<Color> _colors = [AppColors.navy, Colors.black, Colors.grey, Colors.brown, Colors.white];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: _colors.asMap().entries.map((entry) {
            final isSelected = entry.key == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = entry.key),
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.charcoal : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
