import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final void Function(String? size, String? color, String? fit) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedSize;
  String? _selectedColor;
  String? _selectedFit;

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
            children: ['XS', 'S', 'M', 'L', 'XL', 'XXL'].map((s) {
              final sel = _selectedSize == s;
              return FilterChip(
                label: Text(s),
                selected: sel,
                onSelected: (_) => setState(() => _selectedSize = sel ? null : s),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Fit', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['True to Size', 'Runs Small', 'Runs Large'].map((f) {
              final sel = _selectedFit == f;
              return FilterChip(
                label: Text(f),
                selected: sel,
                onSelected: (_) => setState(() => _selectedFit = sel ? null : f),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_selectedSize, _selectedColor, _selectedFit);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Apply', style: TextStyle(color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
