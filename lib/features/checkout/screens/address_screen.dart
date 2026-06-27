import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Shipping Address',
            style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CustomTextField(label: 'FULL NAME', hint: 'John Doe'),
            const SizedBox(height: 12),
            const CustomTextField(
                label: 'PHONE', hint: '+1 234 567 8900', keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            const CustomTextField(
                label: 'ADDRESS', hint: '123 Main St, Apt 4', maxLines: 3),
            const SizedBox(height: 24),
            CustomButton(
              label: 'CONTINUE TO PAYMENT',
              onPressed: () {
                Navigator.pop(context);
                context.push('/payment');
              },
            ),
          ],
        ),
      ),
    );
  }
}
