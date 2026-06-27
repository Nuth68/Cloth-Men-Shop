import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/monograph_header.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _addressType = 'Home';

  // Mock saved addresses
  static const _savedAddresses = [
    {'name': 'John Doe', 'phone': '+855 12 345 678', 'street': '123 Street 289', 'city': 'Phnom Penh', 'type': 'Home'},
    {'name': 'John Doe', 'phone': '+855 98 765 432', 'street': '45 Street 315, Toul Kork', 'city': 'Phnom Penh', 'type': 'Work'},
  ];

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); _streetCtrl.dispose(); _cityCtrl.dispose(); _zipCtrl.dispose(); super.dispose(); }

  void _useSavedAddress(Map<String, String> addr) {
    _nameCtrl.text = addr['name'] ?? '';
    _phoneCtrl.text = addr['phone'] ?? '';
    _streetCtrl.text = addr['street'] ?? '';
    _cityCtrl.text = addr['city'] ?? '';
    setState(() => _addressType = addr['type'] ?? 'Home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tx = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, child: Column(children: [
        MonographHeader(onBack: () => context.pop(), onBag: () => context.push('/cart'), onNotification: () => context.push('/notifications'), elevated: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Saved addresses
              if (_savedAddresses.isNotEmpty) ...[
                Text('SAVED ADDRESSES', style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
                const SizedBox(height: 10),
                ..._savedAddresses.map((addr) => GestureDetector(
                  onTap: () => _useSavedAddress(addr),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.monoDivider, width: 0.5)),
                    child: Row(children: [
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.monoLightGrey.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)), child: Icon(addr['type'] == 'Work' ? Icons.work_outline : Icons.home_outlined, size: 20, color: AppColors.monoGrey)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(addr['type']!, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: tx)),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text('SAVED', style: AppTypography.labelSmall.copyWith(fontSize: 9, color: AppColors.success))),
                        ]),
                        const SizedBox(height: 2),
                        Text('${addr['street']}, ${addr['city']}', style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(addr['phone']!, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                      ])),
                      Icon(Icons.chevron_right, color: AppColors.monoGrey, size: 18),
                    ]),
                  ),
                )),
                const SizedBox(height: 24),
              ],

              // Address Type
              Text('ADDRESS TYPE', style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
              const SizedBox(height: 8),
              Row(children: ['Home', 'Work', 'Other'].map((t) {
                final sel = _addressType == t;
                return GestureDetector(
                  onTap: () => setState(() => _addressType = t),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(color: sel ? AppColors.monoBlack : AppColors.surface(context), borderRadius: BorderRadius.circular(10), border: Border.all(color: sel ? AppColors.monoBlack : AppColors.monoDivider)),
                    child: Text(t, style: AppTypography.bodySmall.copyWith(color: sel ? AppColors.white : AppColors.monoGrey, fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                  ),
                );
              }).toList()),
              const SizedBox(height: 20),

              // Form fields
              Text(l10n.translate('fullName'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
              const SizedBox(height: 6),
              TextFormField(controller: _nameCtrl, style: AppTypography.bodyLarge.copyWith(color: tx), decoration: _decor(l10n.translate('fullNameHint'))),
              const SizedBox(height: 14),
              Text(l10n.translate('phoneNumber'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
              const SizedBox(height: 6),
              TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, style: AppTypography.bodyLarge.copyWith(color: tx), decoration: _decor(l10n.translate('phoneHint'))),
              const SizedBox(height: 14),
              Text(l10n.translate('shippingAddress'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
              const SizedBox(height: 6),
              TextFormField(controller: _streetCtrl, maxLines: 2, style: AppTypography.bodyLarge.copyWith(color: tx), decoration: _decor(l10n.translate('addressHint'))),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l10n.translate('city'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
                  const SizedBox(height: 6),
                  TextFormField(controller: _cityCtrl, style: AppTypography.bodyLarge.copyWith(color: tx), decoration: _decor('')),
                ])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l10n.translate('zipCode'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
                  const SizedBox(height: 6),
                  TextFormField(controller: _zipCtrl, keyboardType: TextInputType.number, style: AppTypography.bodyLarge.copyWith(color: tx), decoration: _decor('')),
                ])),
              ]),
              const SizedBox(height: 28),
              CustomButton(label: l10n.translate('continueToPayment'), onPressed: () { context.pop(); context.push('/payment'); }),
              const SizedBox(height: 16),
            ])),
          ),
        ),
      ])),
    );
  }

  InputDecoration _decor(String hint) => InputDecoration(
    hintText: hint, hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.monoGrey),
    filled: true, fillColor: AppColors.monoLightGrey.withValues(alpha: 0.3),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.monoBlack, width: 1)),
  );
}
