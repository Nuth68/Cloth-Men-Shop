import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/monograph_header.dart';

class _StoreData {
  final String name, address, hours, phone;
  final double lat, lng, rating;
  final bool hasTryOn, isOpenNow;
  const _StoreData({required this.name, required this.address, required this.lat, required this.lng, required this.hours, required this.phone, this.hasTryOn = false, this.isOpenNow = true, this.rating = 4.5});
}

const _stores = [
  _StoreData(name: 'Steav Flagship', address: '#45, Street 315, Toul Kork', lat: 11.5760, lng: 104.8980, hours: '9:00 AM - 9:00 PM', phone: '+855 23 456 7801', hasTryOn: true, rating: 4.8),
  _StoreData(name: 'Steav Boutique', address: '#12, Street 57, BKK1', lat: 11.5460, lng: 104.9230, hours: '9:00 AM - 9:00 PM', phone: '+855 23 456 7802', hasTryOn: true, rating: 4.7),
  _StoreData(name: 'Steav Riverside', address: '#78, Sisowath Quay', lat: 11.5700, lng: 104.9320, hours: '9:00 AM - 9:00 PM', phone: '+855 23 456 7803', rating: 4.5),
  _StoreData(name: 'Steav TK Avenue', address: '#203, TK Avenue, Toul Kork', lat: 11.5810, lng: 104.8900, hours: '9:00 AM - 9:00 PM', phone: '+855 23 456 7804', hasTryOn: true, rating: 4.6),
  _StoreData(name: 'Steav Collection', address: '#5, Street 440, Tuol Tom Poung', lat: 11.5310, lng: 104.9130, hours: '9:00 AM - 9:00 PM', phone: '+855 23 456 7805', rating: 4.4),
  _StoreData(name: 'Steav Outlet', address: '#88, AEON Mall Sen Sok', lat: 11.5920, lng: 104.8750, hours: '9:00 AM - 9:00 PM', phone: '+855 23 456 7806', hasTryOn: true, isOpenNow: false, rating: 4.3),
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  _StoreData? _selectedStore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(top: false, child: Column(children: [
        MonographHeader(onBack: () => Navigator.pop(context), onBag: () {}, onNotification: () {}, elevated: true),
        Expanded(
          child: Stack(children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(11.5564, 104.9282),
                initialZoom: 12.5,
                minZoom: 4, maxZoom: 18,
                onTap: (_, __) => setState(() => _selectedStore = null),
              ),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.steav.fashion'),
                MarkerLayer(markers: _stores.map((s) => Marker(
                  point: LatLng(s.lat, s.lng), width: 80, height: 50,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedStore = s),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: _selectedStore == s ? AppColors.monoBlack : Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4)]),
                        child: Text(s.name, style: AppTypography.labelSmall.copyWith(fontSize: 9, color: _selectedStore == s ? Colors.white : AppColors.monoBlack, fontWeight: FontWeight.w600)),
                      ),
                      Icon(Icons.location_on, size: 28, color: _selectedStore == s ? AppColors.monoBlack : Colors.red),
                    ]),
                  ),
                )).toList()),
              ],
            ),
            // Store card at bottom
            if (_selectedStore != null)
              Positioned(bottom: 16, left: 16, right: 16, child: _storeCard(_selectedStore!, l10n, isDark)),
          ]),
        ),
      ])),
    );
  }

  Widget _storeCard(_StoreData s, AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: AppTypography.heading2.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 2),
            Text(s.address, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
          ])),
          if (s.hasTryOn) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(l10n.translate('tryOnInStore'), style: AppTypography.labelSmall.copyWith(fontSize: 9, color: AppColors.success))),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _infoChip(Icons.access_time, s.hours),
          const SizedBox(width: 16),
          _infoChip(Icons.star, '${s.rating}'),
          const Spacer(),
          SizedBox(height: 36, child: ElevatedButton.icon(
            onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${s.lat},${s.lng}')),
            icon: const Icon(Icons.directions, size: 16),
            label: Text(l10n.translate('getDirections'), style: AppTypography.button.copyWith(fontSize: 11)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.monoBlack, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12)),
          )),
        ]),
      ]),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: AppColors.monoGrey),
      const SizedBox(width: 4),
      Text(text, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.monoGrey)),
    ]);
  }
}
