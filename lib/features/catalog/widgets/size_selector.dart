import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({super.key});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String _selected = 'M';
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: _sizes.map((size) {
            final isSelected = size == _selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (_) => setState(() => _selected = size),
                selectedColor: AppColors.charcoal,
                backgroundColor: AppColors.lightGray,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.charcoal,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
