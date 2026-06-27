import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'custom_button.dart';

class StoreInfo {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String hours;
  final String phone;
  final double distanceKm;
  final double rating;
  final bool isOpenNow;
  final bool hasTryOn;

  const StoreInfo({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.hours,
    required this.phone,
    this.distanceKm = 0.0,
    this.rating = 0.0,
    this.isOpenNow = true,
    this.hasTryOn = false,
  });
}

void showStoreBottomSheet(BuildContext context, StoreInfo store) {
  final l10n = AppLocalizations.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.monoDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Store name
              Text(
                store.name,
                style: AppTypography.heading2,
              ),
              const SizedBox(height: 16),

              // Address
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: store.address,
              ),
              const SizedBox(height: 12),

              // Hours
              _InfoRow(
                icon: Icons.access_time,
                text: store.hours,
              ),
              const SizedBox(height: 12),

              // Phone
              _InfoRow(
                icon: Icons.phone_outlined,
                text: store.phone,
              ),

              // Try On badge
              if (store.hasTryOn) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.translate('tryOnInStore'),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Get Directions button
              CustomButton(
                label: l10n.translate('getDirections'),
                icon: Icons.directions_outlined,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  final url =
                      'https://www.google.com/maps/dir/?api=1&destination=${store.lat},${store.lng}';
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.monoGrey,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
    );
  }
}
