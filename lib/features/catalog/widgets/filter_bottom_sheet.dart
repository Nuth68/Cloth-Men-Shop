import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/l10n/app_localizations.dart';

class FilterBottomSheet extends StatefulWidget {
  final void Function(
    String? size,
    String? color,
    String? fit,
    double minPrice,
    double maxPrice,
    List<String> brands,
  ) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedSize;
  String? _selectedColor;
  String? _selectedFit;
  double _minPrice = 0;
  double _maxPrice = 500;
  final List<String> _selectedBrands = [];

  int get _activeFilterCount =>
      (_selectedSize != null ? 1 : 0) +
      (_selectedColor != null ? 1 : 0) +
      (_selectedFit != null ? 1 : 0) +
      ((_minPrice != 0 || _maxPrice != 500) ? 1 : 0) +
      _selectedBrands.length;

  void _clearAll() {
    setState(() {
      _selectedSize = null;
      _selectedColor = null;
      _selectedFit = null;
      _minPrice = 0;
      _maxPrice = 500;
      _selectedBrands.clear();
    });
    AppHaptics.light();
  }

  // ── Color chip definitions ──
  static const _colorChips = <_ColorChipData>[
    _ColorChipData(name: 'Black', color: Color(0xFF111111)),
    _ColorChipData(name: 'White', color: Color(0xFFFFFFFF)),
    _ColorChipData(name: 'Navy', color: Color(0xFF1B2A4A)),
    _ColorChipData(name: 'Grey', color: Color(0xFF8A8A8A)),
    _ColorChipData(name: 'Brown', color: Color(0xFF8B5E3C)),
    _ColorChipData(name: 'Green', color: Color(0xFF4A6B4A)),
    _ColorChipData(name: 'Burgundy', color: Color(0xFF722F37)),
  ];

  // ── Brand definitions ──
  static const _brands = [
    'Steav',
    'Urban Thread',
    'Modernist',
    'Heritage Co',
    'Drift',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
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
                      l10n.translate('filter'),
                      style: AppTypography.heading2.copyWith(),
                    ),
                    if (_activeFilterCount > 0)
                      GestureDetector(
                        onTap: _clearAll,
                        child: Text(
                          'CLEAR ALL',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.error),
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
                      // ── Size ──
                      Text('Size', style: AppTypography.labelLarge.copyWith()),
                      const SizedBox(height: 10),
                      Wrap(spacing: 8, runSpacing: 8,
                        children: ['XS', 'S', 'M', 'L', 'XL', 'XXL'].map((s) => _FilterChip(label: s, selected: _selectedSize == s, onTap: () {
                          AppHaptics.selection();
                          setState(() => _selectedSize = _selectedSize == s ? null : s);
                        })).toList(),
                      ),
                      const SizedBox(height: 20),
                      // ── Fit ──
                      Text('Fit', style: AppTypography.labelLarge.copyWith()),
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
                      const SizedBox(height: 24),

                      // ── Color ──
                      Text(
                        l10n.translate('color'),
                        style: AppTypography.labelSmall.copyWith(),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _colorChips.map((chip) {
                          final isSelected = _selectedColor == chip.name;
                          return GestureDetector(
                            onTap: () {
                              AppHaptics.selection();
                              setState(() => _selectedColor =
                                  isSelected ? null : chip.name);
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: chip.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: chip.name == 'White'
                                      ? AppColors.monoDivider
                                      : Colors.transparent,
                                  width: 0.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.monoBlack
                                              .withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? Icon(
                                      chip.name == 'White'
                                          ? Icons.check
                                          : Icons.check,
                                      size: 16,
                                      color: chip.name == 'White'
                                          ? AppColors.monoBlack
                                          : Colors.white,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // ── Price Range ──
                      Text(
                        l10n.translate('priceRange'),
                        style: AppTypography.labelSmall.copyWith(),
                      ),
                      const SizedBox(height: 16),
                      RangeSlider(
                        values: RangeValues(_minPrice, _maxPrice),
                        min: 0,
                        max: 500,
                        divisions: 50,
                        activeColor: AppColors.monoBlack,
                        inactiveColor: AppColors.monoDivider,
                        labels: RangeLabels(
                          '\$${_minPrice.round()}',
                          '\$${_maxPrice.round()}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _minPrice = values.start;
                            _maxPrice = values.end;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '\$${_minPrice.round()} - \$${_maxPrice.round()}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.monoGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Brand ──
                      Text(
                        l10n.translate('brand'),
                        style: AppTypography.labelSmall.copyWith(),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _brands.map((b) {
                          final isSelected = _selectedBrands.contains(b);
                          return _FilterChip(
                            label: b,
                            selected: isSelected,
                            onTap: () {
                              AppHaptics.selection();
                              setState(() {
                                if (isSelected) {
                                  _selectedBrands.remove(b);
                                } else {
                                  _selectedBrands.add(b);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
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
                        _selectedSize,
                        _selectedColor,
                        _selectedFit,
                        _minPrice,
                        _maxPrice,
                        List.unmodifiable(_selectedBrands),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.monoBlack,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _activeFilterCount > 0
                          ? 'SHOW RESULTS ($_activeFilterCount)'
                          : 'SHOW ALL RESULTS',
                      style: AppTypography.button.copyWith(color: AppColors.surface(context)),
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

class _ColorChipData {
  final String name;
  final Color color;
  const _ColorChipData({required this.name, required this.color});
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.monoBlack : AppColors.monoDivider,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: selected
                ? AppColors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
