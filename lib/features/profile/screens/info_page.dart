import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/monograph_header.dart';

class InfoPage extends StatefulWidget {
  final String title;
  final String type; // 'help', 'about', 'privacy'
  const InfoPage({super.key, required this.title, required this.type});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tx = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.white,
      body: SafeArea(top: false, child: Column(children: [
        MonographHeader(onBack: () => context.pop(), onBag: () => context.push('/cart'), onNotification: () => context.push('/notifications'), elevated: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.title, style: AppTypography.heading1.copyWith(color: tx)),
              const SizedBox(height: 24),
              if (widget.type == 'help') ..._buildHelp(tx, isDark),
              if (widget.type == 'about') ..._buildAbout(tx, isDark),
              if (widget.type == 'privacy') ..._buildPrivacy(tx, isDark),
            ]),
          ),
        ),
      ])),
    );
  }

  List<Widget> _buildHelp(Color tx, bool isDark) {
    final items = [
      ('Orders & Shipping', 'Track your order anytime from the Orders page. We offer free standard shipping on orders over \$100. Express delivery is available for \$15. Returns are free within 30 days.'),
      ('Size & Fit Guide', 'Not sure about your size? Visit our Size Guide for detailed measurements. Still unsure? Book a free consultation with our personal stylists who can help you find the perfect fit.'),
      ('Payment Methods', 'We accept Visa, Mastercard, American Express, and PayPal. All transactions are encrypted and secure. Your payment information is never stored on our servers.'),
      ('Contact Us', 'Email: support@steavfashion.com\nPhone: +855 23 456 7890\nHours: 9:00 AM - 9:00 PM daily\n\nVisit us at any of our 6 stores across Phnom Penh.'),
      ('FAQs', '• Can I modify my order? Yes, within 1 hour of placing.\n• How long does shipping take? 3-5 business days standard.\n• Do you ship internationally? Currently within Cambodia only.\n• What if my item doesn\'t fit? Free returns within 30 days.'),
    ];
    return _buildAccordionList(items, tx, isDark);
  }

  List<Widget> _buildAbout(Color tx, bool isDark) {
    return [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: isDark ? AppColors.darkCard : AppColors.monoOffWhite, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Steav Fashion', style: AppTypography.heading2.copyWith(color: tx)),
          const SizedBox(height: 8),
          Text('Redefining Modern Menswear', style: AppTypography.bodySmall.copyWith(color: AppColors.brass, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text('Founded in 2024, Steav Fashion brings curated, high-quality menswear to Cambodia. We believe in timeless style, impeccable craftsmanship, and accessible luxury. Our collections blend classic tailoring with contemporary design, sourced from the finest materials.', style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey, height: 1.6)),
        ]),
      ),
      const SizedBox(height: 20),
      _infoRow('Version', '1.0.0', tx),
      _infoRow('Build', '2024.1', tx),
      _infoRow('Platform', 'iOS • Android', tx),
      _infoRow('Made in', 'Phnom Penh, Cambodia', tx),
      const SizedBox(height: 20),
      Text('© 2024 Steav Fashion. All rights reserved.', style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
    ];
  }

  List<Widget> _buildPrivacy(Color tx, bool isDark) {
    final items = [
      ('Information We Collect', 'We collect only the information necessary to process your orders: name, email, shipping address, and phone number. Payment information is processed by our secure payment partners and never stored on our servers.'),
      ('How We Use Your Data', '• Process and fulfill your orders\n• Send order confirmations and shipping updates\n• Improve your shopping experience\n• Send promotional offers (only with your consent)\n• Respond to your inquiries and support requests'),
      ('Data Security', 'All data is encrypted using industry-standard SSL/TLS protocols. We use secure servers and regularly audit our security practices. Your account is protected by encrypted password storage.'),
      ('Your Rights', '• Access your personal data anytime\n• Request correction of inaccurate data\n• Request deletion of your data\n• Opt out of marketing communications\n• Export your data in a portable format\n\nTo exercise any of these rights, contact us at privacy@steavfashion.com.'),
      ('Cookies & Tracking', 'We use essential cookies for site functionality (cart, login). Analytics cookies help us improve your experience. You can disable non-essential cookies in your browser settings. We do not use third-party tracking cookies without your explicit consent.'),
    ];
    return _buildAccordionList(items, tx, isDark);
  }

  List<Widget> _buildAccordionList(List<(String, String)> items, Color tx, bool isDark) {
    return items.map((item) {
      final title = item.$1;
      final content = item.$2;
      final expanded = _expanded[title] ?? false;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(border: Border.all(color: AppColors.monoDivider, width: 0.5), borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          InkWell(
            onTap: () => setState(() => _expanded[title] = !expanded),
            borderRadius: BorderRadius.vertical(top: const Radius.circular(10), bottom: expanded ? Radius.zero : const Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Expanded(child: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: tx))),
                AnimatedRotation(turns: expanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.monoGrey)),
              ]),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Text(content, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey, height: 1.5))),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ]),
      );
    }).toList();
  }

  Widget _infoRow(String label, String value, Color tx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        SizedBox(width: 100, child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey))),
        Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: tx)),
      ]),
    );
  }
}
