import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';

class SizeSelectorController {
  String _selected = 'M';
  String get selectedSize => _selected;

  final _controller = StreamController<String>.broadcast();
  Stream<String> get onChanged => _controller.stream;

  void select(String size) {
    _selected = size;
    _controller.add(size);
  }

  void dispose() => _controller.close();
}

class SizeSelector extends StatefulWidget {
  final SizeSelectorController? controller;

  const SizeSelector({super.key, this.controller});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  late String _selected;
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _selected = widget.controller?.selectedSize ?? 'M';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _sizes.map((size) {
            final isSelected = size == _selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (_) {
                  AppHaptics.selection();
                  setState(() => _selected = size);
                  widget.controller?.select(size);
                },
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
