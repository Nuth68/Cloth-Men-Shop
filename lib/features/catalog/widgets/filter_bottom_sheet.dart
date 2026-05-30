import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          const Text('Size', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['S', 'M', 'L', 'XL', 'XXL'].map((s) => FilterChip(label: Text(s), onSelected: (_) {})).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Fit', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Slim', 'Regular', 'Relaxed'].map((f) => FilterChip(label: Text(f), onSelected: (_) {})).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Apply', style: TextStyle(color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
