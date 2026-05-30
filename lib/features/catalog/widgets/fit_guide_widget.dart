import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FitGuideWidget extends StatefulWidget {
  const FitGuideWidget({super.key});

  @override
  State<FitGuideWidget> createState() => _FitGuideWidgetState();
}

class _FitGuideWidgetState extends State<FitGuideWidget> {
  String _selected = 'Regular';
  final List<String> _fits = ['Slim', 'Regular', 'Relaxed'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: _fits.map((fit) {
            final isSelected = fit == _selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(fit),
                selected: isSelected,
                onSelected: (_) => setState(() => _selected = fit),
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
