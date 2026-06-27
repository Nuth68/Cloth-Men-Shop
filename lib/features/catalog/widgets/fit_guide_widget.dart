import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';

class FitGuideController {
  String _selected = 'Regular';
  String get selectedFit => _selected;

  final _controller = StreamController<String>.broadcast();
  Stream<String> get onChanged => _controller.stream;

  void select(String fit) {
    _selected = fit;
    _controller.add(fit);
  }

  void dispose() => _controller.close();
}

class FitGuideWidget extends StatefulWidget {
  final FitGuideController? controller;

  const FitGuideWidget({super.key, this.controller});

  @override
  State<FitGuideWidget> createState() => _FitGuideWidgetState();
}

class _FitGuideWidgetState extends State<FitGuideWidget> {
  late String _selected;
  final List<String> _fits = ['Slim', 'Regular', 'Relaxed'];

  @override
  void initState() {
    super.initState();
    _selected = widget.controller?.selectedFit ?? 'Regular';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fit',
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.monoBlack,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _fits.map((fit) {
            final isSelected = fit == _selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(fit),
                selected: isSelected,
                onSelected: (_) {
                  AppHaptics.selection();
                  setState(() => _selected = fit);
                  widget.controller?.select(fit);
                },
                selectedColor: AppColors.monoBlack,
                backgroundColor: AppColors.monoLightGrey,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.monoBlack,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
<<<<<<< Updated upstream
                  borderRadius: BorderRadius.circular(12),
=======
                  borderRadius: BorderRadius.circular(2),
>>>>>>> Stashed changes
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
