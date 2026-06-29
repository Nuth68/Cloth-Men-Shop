import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';

class StylistBookingScreen extends StatefulWidget {
  const StylistBookingScreen({super.key});
  @override
  State<StylistBookingScreen> createState() => _StylistBookingScreenState();
}

class _StylistBookingScreenState extends State<StylistBookingScreen> {
  final _pageCtrl = PageController(viewportFraction: 0.85);
  int _selStylist = 0;
  int _selDay = 0;
  int _selTime = -1;

  static final _stylists = [
    _S(
      "Julian Vane",
      "Bespoke Tailoring",
      "15 yrs · 4.9 · 230",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500",
      "Savile Row trained. Precision blazers and formal wear.",
    ),
    _S(
      "Elena Rossi",
      "Casual Luxe",
      "8 yrs · 4.8 · 184",
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500",
      "Italian knitwear, denim curation, relaxed silhouettes.",
    ),
    _S(
      "Marcus Thorne",
      "Archive & Vintage",
      "12 yrs · 5.0 · 97",
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500",
      "Rare archival sourcing. Statement pieces worldwide.",
    ),
  ];

  static final _times = [
    "09:00",
    "10:00",
    "11:00",
    "13:00",
    "14:30",
    "16:00",
    "17:30",
  ];
  static final _wd = ["M", "T", "W", "T", "F", "S", "S"];
  List<DateTime> get _days =>
      List.generate(10, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx);
    final d = Theme.of(ctx).brightness == Brightness.dark;
    final bg = d ? AppColors.darkBg : AppColors.monoOffWhite;
    final sf = d ? AppColors.darkCard : AppColors.white;
    final tx = d ? AppColors.white : AppColors.monoBlack;
    final sb = d ? AppColors.brass : AppColors.monoBlack;
    final st = d ? AppColors.monoBlack : AppColors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onSearch: () => context.push('/search'),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _lbl(l10n.translate('selectStylist')),
                    const SizedBox(height: 14),
                    _carousel(d, bg, tx),
                    const SizedBox(height: 28),
                    _lbl(l10n.translate('selectDate')),
                    const SizedBox(height: 14),
                    _dates(d, sf, tx, sb, st),
                    const SizedBox(height: 28),
                    _lbl(l10n.translate('selectTime')),
                    const SizedBox(height: 14),
                    _times_(d, sf, tx, sb, st),
                    const SizedBox(height: 32),
                    _summary(d, sf, tx),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            AppHaptics.heavy();
                            final s = _stylists[_selStylist];
                            context.push(
                              '/stylist-chat',
                              extra: {
                                'conversationId': 'conv_${s.n}',
                                'stylistName': s.n,
                                'stylistAvatarUrl': s.img,
                                'stylistSpecialty':
                                    '${s.sp.toUpperCase()} ${l10n.translate('expertStylist')}',
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: d
                                ? AppColors.brass
                                : AppColors.monoBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _selTime >= 0
                                ? '${l10n.translate('bookAppointment')} · ${_wd[_days[_selDay].weekday - 1]} ${_days[_selDay].day} at ${_times[_selTime]}'
                                : l10n.translate('bookAppointment'),
                            style: AppTypography.button.copyWith(
                              color: d ? AppColors.monoBlack : AppColors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Text(
      t,
      style: AppTypography.labelSmall.copyWith(
        letterSpacing: 2,
        color: AppColors.monoGrey,
      ),
    ),
  );

  Widget _carousel(bool d, Color bg, Color tx) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 340,
      child: PageView.builder(
        controller: _pageCtrl,
        itemCount: _stylists.length,
        onPageChanged: (i) {
          AppHaptics.selection();
          setState(() => _selStylist = i);
        },
        itemBuilder: (_, i) {
          final s = _stylists[i];
          final sel = i == _selStylist;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: i == 0 ? 16 : 8,
              right: i == _stylists.length - 1 ? 16 : 8,
              top: 4,
              bottom: 4,
            ),
            child: GestureDetector(
              onTap: () {
                AppHaptics.selection();
                _pageCtrl.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: sel
                      ? [
                          BoxShadow(
                            color: AppColors.monoBlack.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: s.img,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) =>
                            Container(color: AppColors.monoLightGrey),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      if (sel)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.translate('selected'),
                              style: AppTypography.labelSmall.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              s.n,
                              style: AppTypography.serif(
                                22,
                                weight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.sp.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.brass,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: AppColors.brass,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  s.st,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.bio,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dates(bool d, Color sf, Color tx, Color sb, Color st) {
    final m = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final day = _days[i];
          final sel = i == _selDay;
          return GestureDetector(
            onTap: () {
              AppHaptics.selection();
              setState(() => _selDay = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              decoration: BoxDecoration(
                color: sel ? sb : sf,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sel ? sb : AppColors.monoDivider),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _wd[day.weekday - 1],
                    style: AppTypography.labelSmall.copyWith(
                      color: sel
                          ? (d ? AppColors.monoBlack : Colors.white70)
                          : AppColors.monoGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${day.day}",
                    style: AppTypography.heading2.copyWith(
                      color: sel ? st : tx,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m[day.month - 1],
                    style: AppTypography.labelSmall.copyWith(
                      color: sel
                          ? (d ? AppColors.monoBlack : Colors.white54)
                          : AppColors.monoGrey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _times_(bool d, Color sf, Color tx, Color sb, Color st) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(_times.length, (i) {
          final sel = i == _selTime;
          return GestureDetector(
            onTap: () {
              AppHaptics.selection();
              setState(() => _selTime = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: sel ? sb : sf,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sel ? sb : AppColors.monoDivider),
              ),
              child: Text(
                _times[i],
                style: AppTypography.bodyMedium.copyWith(
                  color: sel ? st : tx,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _summary(bool d, Color sf, Color tx) {
    final l10n = AppLocalizations.of(context);
    final s = _stylists[_selStylist];
    final day = _days[_selDay];
    final t = _selTime >= 0 ? _times[_selTime] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: sf,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.monoDivider),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: s.img,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.monoLightGrey,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('minConsultation'),
                    style: AppTypography.heading2.copyWith(color: tx),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.translate('with')} ${s.n}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.monoGrey,
                    ),
                  ),
                  if (t != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "${_wd[day.weekday - 1]} ${day.day}/${day.month} · $t",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.brass,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.monoLightGrey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.videocam_outlined, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _S {
  final String n, sp, st, img, bio;
  const _S(this.n, this.sp, this.st, this.img, this.bio);
}
