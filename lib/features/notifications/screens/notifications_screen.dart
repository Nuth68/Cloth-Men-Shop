import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/monograph_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<_Notification> _notifications;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final l10n = AppLocalizations.of(context);
      _notifications = [
        _Notification(
          type: _NotifType.order,
          title: l10n.translate('orderConfirmed'),
          message: l10n.translate('notifOrderMsg'),
          time: DateTime.now().subtract(const Duration(minutes: 12)),
          isRead: false,
          imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=200&q=80',
        ),
        _Notification(
          type: _NotifType.shipping,
          title: l10n.translate('orderShipped'),
          message: l10n.translate('notifShippingMsg'),
          time: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
          imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=200&q=80',
        ),
        _Notification(
          type: _NotifType.promo,
          title: l10n.translate('seasonSale'),
          message: l10n.translate('notifSaleMsg'),
          time: DateTime.now().subtract(const Duration(hours: 8)),
          isRead: true,
          imageUrl: 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=200&q=80',
        ),
        _Notification(
          type: _NotifType.stylist,
          title: l10n.translate('stylistMessage'),
          message: l10n.translate('notifStylistMsg'),
          time: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
        ),
        _Notification(
          type: _NotifType.newArrival,
          title: l10n.translate('newDrop'),
          message: l10n.translate('notifNewDropMsg'),
          time: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
          imageUrl: 'https://images.unsplash.com/photo-1512149177596-f817c7ef5d4c?w=200&q=80',
        ),
        _Notification(
          type: _NotifType.delivered,
          title: l10n.translate('orderDelivered'),
          message: l10n.translate('notifDeliveredMsg'),
          time: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
          imageUrl: 'https://images.unsplash.com/photo-1601924582970-9238bcb495d9?w=200&q=80',
        ),
      ];
      _didInit = true;
    }
  }

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
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.notifications_none_outlined, size: 56, color: AppColors.monoGrey),
                          const SizedBox(height: 16),
                          Text(l10n.translate('noNotifications'), style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final n = _notifications[i];
                        return _NotificationCard(
                          notification: n,
                          onTap: () => setState(() => n.isRead = true),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final _Notification notification;
  final VoidCallback onTap;
  const _NotificationCard({required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case _NotifType.order: return Icons.receipt_long_outlined;
      case _NotifType.shipping: return Icons.local_shipping_outlined;
      case _NotifType.delivered: return Icons.check_circle_outline;
      case _NotifType.promo: return Icons.local_offer_outlined;
      case _NotifType.stylist: return Icons.chat_outlined;
      case _NotifType.newArrival: return Icons.new_releases_outlined;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case _NotifType.order: return AppColors.monoBlack;
      case _NotifType.shipping: return AppColors.warning;
      case _NotifType.delivered: return AppColors.success;
      case _NotifType.promo: return AppColors.error;
      case _NotifType.stylist: return AppColors.brass;
      case _NotifType.newArrival: return AppColors.monoBlack;
    }
  }

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.white : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.monoDivider, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon, size: 20, color: _iconColor),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(notification.title,
                            style: AppTypography.bodyMedium.copyWith(
                                fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w700,
                               )),
                      ),
                      const SizedBox(width: 8),
                      Text(_timeAgo(notification.time),
                          style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notification.message, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                ],
              ),
            ),
            // Unread dot
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 6),
                child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, shape: BoxShape.circle)),
              ),
          ],
        ),
      ),
    );
  }
}

enum _NotifType { order, shipping, delivered, promo, stylist, newArrival }

class _Notification {
  final _NotifType type;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final String imageUrl;

  _Notification({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.imageUrl,
  });
}
