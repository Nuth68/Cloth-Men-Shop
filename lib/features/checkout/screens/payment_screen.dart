import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.monoBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Payment',
            style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CARD DETAILS',
                style: AppTypography.labelSmall.copyWith(
                    letterSpacing: 1.5, color: AppColors.monoGrey)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.monoBlack,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('••••',
                          style: TextStyle(fontSize: 22, color: Colors.white70, letterSpacing: 4)),
                      const Icon(Icons.credit_card, color: Colors.white70, size: 28),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _DarkField(controller: _cardCtrl, hint: 'Card Number', maxLength: 19, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _DarkField(controller: _expiryCtrl, hint: 'MM/YY')),
                      const SizedBox(width: 24),
                      Expanded(child: _DarkField(controller: _cvvCtrl, hint: 'CVV', obscure: true, maxLength: 4, keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DarkField(controller: _nameCtrl, hint: 'Cardholder Name'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5A3D).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text('Secured with 256-bit encryption',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTypography.bodyLarge.copyWith(color: AppColors.monoGrey)),
                Text('\$660.00', style: AppTypography.price.copyWith(color: AppColors.monoBlack)),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'PAY \$660.00',
              onPressed: () {
                AppHaptics.heavy();
                context.go('/orders');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final int? maxLength;
  final TextInputType? keyboardType;
  const _DarkField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.maxLength,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: InputBorder.none,
        counterText: '',
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
