import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/haptics.dart';

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

  int get _activeFilterCount =>
      (_selectedSize != null ? 1 : 0) +
      (_selectedColor != null ? 1 : 0) +
      (_selectedFit != null ? 1 : 0);

  void _clearAll() {
    setState(() {
      _selectedSize = null;
      _selectedColor = null;
      _selectedFit = null;
    });
    AppHaptics.light();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              AppDecorations.dragHandle,
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: AppTypography.heading2.copyWith(
                        color: AppColors.monoBlack,
                      ),
                    ),
                    if (_activeFilterCount > 0)
                      GestureDetector(
                        onTap: _clearAll,
                        child: Text(
                          'CLEAR ALL',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              // Filter content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Size
                      Text(
                        'Size',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.monoBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['XS', 'S', 'M', 'L', 'XL', 'XXL']
                            .map((s) => _FilterChip(
                                  label: s,
                                  selected: _selectedSize == s,
                                  onTap: () {
                                    AppHaptics.selection();
                                    setState(() => _selectedSize =
                                        _selectedSize == s ? null : s);
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      // Fit
                      Text(
                        'Fit',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.monoBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['True to Size', 'Runs Small', 'Runs Large']
                            .map((f) => _FilterChip(
                                  label: f,
                                  selected: _selectedFit == f,
                                  onTap: () {
                                    AppHaptics.selection();
                                    setState(() => _selectedFit =
                                        _selectedFit == f ? null : f);
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom bar
              Container(
                padding: const EdgeInsets.all(16),
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.monoDivider),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      AppHaptics.medium();
                      widget.onApply(
                          _selectedSize, _selectedColor, _selectedFit);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.monoBlack,
                      shape: RoundedRectangleBorder(
                    ),
                    child: Text(
                      _activeFilterCount > 0
                          ? 'SHOW RESULTS ($_activeFilterCount)'
                          : 'SHOW ALL RESULTS',
                      style: AppTypography.button.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.monoBlack : AppColors.white,
          border: Border.all(
            color:
                selected ? AppColors.monoBlack : AppColors.monoDivider,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: selected ? AppColors.white : AppColors.monoBlack,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
