import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<_SavedCard> _cards = [
    _SavedCard(last4: '4242', brand: 'Visa', expiry: '12/26', isDefault: true),
    _SavedCard(last4: '8888', brand: 'Mastercard', expiry: '08/25', isDefault: false),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onBack: () => context.pop(),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Saved cards ──
                    Text(l10n.translate('savedCards').toUpperCase(), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
                    const SizedBox(height: 12),
                    ..._cards.map((card) => _SavedCardTile(
                      card: card,
                      onDelete: () {
                        AppHaptics.medium();
                        setState(() => _cards.remove(card));
                      },
                      onSetDefault: () {
                        AppHaptics.selection();
                        setState(() {
                          for (var c in _cards) { c.isDefault = c == card; }
                        });
                      },
                    )),
                    const SizedBox(height: 20),
                    // ── Add new card ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => _showAddCardSheet(context),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.translate('addNewCard'), style: AppTypography.button.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.monoDivider),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ── Other methods ──
                    Text(l10n.translate('otherMethods').toUpperCase(), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
                    const SizedBox(height: 12),
                    _MethodRow(icon: Icons.account_balance_wallet, title: l10n.translate('paypal'), subtitle: l10n.translate('connected'), trailing: 'j***@email.com', onTap: () {}),
                    const SizedBox(height: 8),
                    _MethodRow(icon: Icons.phone_iphone, title: l10n.translate('applePay'), subtitle: l10n.translate('readyToUse'), trailing: '', onTap: () {}),
                    const SizedBox(height: 32),
                    // ── Billing address ──
                    Text(l10n.translate('billingAddress').toUpperCase(), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.monoDivider, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 20, color: AppColors.monoGrey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('123 Fashion Ave, Suite 4B', style: AppTypography.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                                const SizedBox(height: 2),
                                Text('New York, NY 10001', style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                              ],
                            ),
                          ),
                          Text(l10n.translate('edit'), style: AppTypography.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddCardSheet(),
    );
  }
}

// ── Saved card tile ──
class _SavedCardTile extends StatelessWidget {
  final _SavedCard card;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _SavedCardTile({required this.card, required this.onDelete, required this.onSetDefault});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.solidDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_card, color: Colors.white70, size: 24),
              const SizedBox(width: 12),
              Text('•••• ${card.last4}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2)),
              if (card.isDefault) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text(l10n.translate('defaultLabel'), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
              const Spacer(),
              Text(card.expiry, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _CardAction(label: l10n.translate('setDefault'), onTap: onSetDefault),
              const SizedBox(width: 16),
              _CardAction(label: l10n.translate('remove'), onTap: onDelete, isDestructive: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _CardAction({required this.label, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { AppHaptics.light(); onTap(); },
      child: Text(label, style: TextStyle(color: isDestructive ? AppColors.error : Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

// ── Other method row ──
class _MethodRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, trailing;
  final VoidCallback onTap;

  const _MethodRow({required this.icon, required this.title, required this.subtitle, required this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { AppHaptics.light(); onTap(); },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.monoDivider, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.monoGrey),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                ],
              ),
            ),
            if (trailing.isNotEmpty)
              Text(trailing, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
          ],
        ),
      ),
    );
  }
}

// ── Add card bottom sheet ──
class _AddCardSheet extends StatefulWidget {
  const _AddCardSheet();
  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _cardCtrl.dispose(); _expiryCtrl.dispose(); _cvvCtrl.dispose(); _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.monoDivider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(l10n.translate('addNewCard'), style: AppTypography.heading2.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 20),
            TextField(
              controller: _cardCtrl, keyboardType: TextInputType.number, maxLength: 19,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(labelText: l10n.translate('cardNumber'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), counterText: ''),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _expiryCtrl, decoration: InputDecoration(labelText: l10n.translate('expiryDate'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _cvvCtrl, obscureText: true, keyboardType: TextInputType.number, maxLength: 4, decoration: InputDecoration(labelText: l10n.translate('cvv'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), counterText: ''))),
            ]),
            const SizedBox(height: 12),
            TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: l10n.translate('cardholderName'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  AppHaptics.medium();
                  context.pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.monoBlack, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: Text(l10n.translate('saveCard'), style: AppTypography.button.copyWith(color: AppColors.white)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Model ──
class _SavedCard {
  final String last4, brand, expiry;
  bool isDefault;
  _SavedCard({required this.last4, required this.brand, required this.expiry, required this.isDefault});
}
