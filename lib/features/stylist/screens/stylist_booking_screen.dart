import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';
<<<<<<< Updated upstream
import '../../../shared/widgets/shimmer_loading.dart';
=======
>>>>>>> Stashed changes

class StylistBookingScreen extends StatefulWidget {
  const StylistBookingScreen({super.key});
  @override
  State<StylistBookingScreen> createState() => _StylistBookingScreenState();
}

class _StylistBookingScreenState extends State<StylistBookingScreen> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.85);
  int _selectedStylist = 0;
  int _selectedDayIndex = 0;
  int _selectedTimeIndex = -1;

<<<<<<< Updated upstream
  static final List<_Stylist> _stylists = [
    _Stylist("Julian Vane", "Bespoke Tailoring", "15 yrs · 4.9 ★ · 230 sessions",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&q=80",
        "Trained at Savile Row. Specializes in precision-fit blazers, overcoats, and formal evening wear."),
    _Stylist("Elena Rossi", "Casual Luxe", "8 yrs · 4.8 ★ · 184 sessions",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&q=80",
        "Effortless elevated casual. Expert in Italian knitwear, denim curation, and relaxed silhouettes."),
    _Stylist("Marcus Thorne", "Archive & Vintage", "12 yrs · 5.0 ★ · 97 sessions",
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&q=80",
        "Rare archival sourcing. Curates one-of-a-kind statement pieces from private collections worldwide."),
=======
  final List<Map<String, String>> stylists = [
    {
      "name": "Julian Vane",
      "specialty": "Formal Wear",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
      "desc":
          "Ex-editorial director with 15 years experience in bespoke tailoring and personal styling."
    },
    {
      "name": "Elena Rossi",
      "specialty": "Casual Luxe",
      "image":
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
      "desc":
          "Specialist in contemporary luxury casual wear with an eye for effortless silhouettes."
    },
    {
      "name": "Marcus Thorne",
      "specialty": "Archive Pieces",
      "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
      "desc":
          "Expert in vintage and archival fashion, curating one-of-a-kind statement pieces."
    },
>>>>>>> Stashed changes
  ];

  static final _times = ["09:00", "10:00", "11:00", "13:00", "14:30", "16:00", "17:30"];
  static final _weekDays = ["M", "T", "W", "T", "F", "S", "S"];

  // Generate next 10 days
  List<DateTime> get _nextDays => List.generate(10, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.monoOffWhite,
      body: SafeArea(
        child: Column(
          children: [
            const MonographHeader(elevated: true),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< Updated upstream
                    const SizedBox(height: 8),
                    // ── Section heading ──
                    _sectionTitle("SELECT YOUR STYLIST"),
                    const SizedBox(height: 14),
                    // ── Stylist carousel ──
                    _buildStylistCarousel(),
                    const SizedBox(height: 28),
                    // ── Date picker ──
                    _sectionTitle("SELECT DATE"),
                    const SizedBox(height: 14),
                    _buildDateStrip(),
                    const SizedBox(height: 28),
                    // ── Time slots ──
                    _sectionTitle("SELECT TIME"),
                    const SizedBox(height: 14),
                    _buildTimeGrid(),
                    const SizedBox(height: 32),
                    // ── Session summary card ──
                    _buildSummary(),
                    const SizedBox(height: 28),
                    // ── Book button ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            AppHaptics.heavy();
                            final s = _stylists[_selectedStylist];
                            final date = _nextDays[_selectedDayIndex];
                            final time = _times[_selectedTimeIndex.clamp(0, _times.length - 1)];
                            context.push('/stylist-chat', extra: {
                              'conversationId': 'conv_${s.name}',
                              'stylistName': s.name,
                              'stylistAvatarUrl': s.imageUrl,
                              'stylistSpecialty': '${s.specialty.toUpperCase()} STYLIST',
                              'appointmentDate': '${date.day}/${date.month} at $time',
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.monoBlack,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            (_selectedTimeIndex >= 0)
                                ? 'BOOK · ${_weekDays[_nextDays[_selectedDayIndex].weekday - 1]} ${_nextDays[_selectedDayIndex].day} at ${_times[_selectedTimeIndex]}'
                                : 'BOOK APPOINTMENT',
                            style: AppTypography.button.copyWith(color: AppColors.white, letterSpacing: 2),
                          ),
=======
                    const SizedBox(height: 20),
                    Text("SELECT STYLIST",
                        style: AppTypography.labelSmall.copyWith(
                            letterSpacing: 1.8,
                            color: AppColors.monoGrey)),
                    const SizedBox(height: 16),
                    ...List.generate(stylists.length, (index) {
                      final stylist = stylists[index];
                      final isSelected = selectedStylist == index;
                      return GestureDetector(
                        onTap: () {
                          AppHaptics.selection();
                          setState(() => selectedStylist = index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.monoBlack
                                  : AppColors.monoDivider,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: stylist["image"]!,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) =>
                                      const SizedBox(
                                          width: 72, height: 72),
                                  errorWidget: (_, __, ___) =>
                                      Container(
                                    width: 72,
                                    height: 72,
                                    color:
                                        AppColors.monoLightGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(stylist["name"]!,
                                        style: AppTypography
                                            .heading2
                                            .copyWith(
                                                color: AppColors
                                                    .monoBlack)),
                                    const SizedBox(height: 4),
                                    Text(stylist["specialty"]!,
                                        style: AppTypography
                                            .labelSmall
                                            .copyWith(
                                                letterSpacing: 1,
                                                color: AppColors
                                                    .monoGrey)),
                                    const SizedBox(height: 6),
                                    Text(stylist["desc"]!,
                                        maxLines: 2,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: AppTypography
                                            .bodySmall
                                            .copyWith(
                                                color: AppColors
                                                    .monoGrey)),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 8),
                                  child: Icon(Icons.check_circle,
                                      color:
                                          AppColors.monoBlack,
                                      size: 20),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Text("SELECT DATE",
                        style: AppTypography.labelSmall.copyWith(
                            letterSpacing: 1.8,
                            color: AppColors.monoGrey)),
                    const SizedBox(height: 12),
                    _CalendarWidget(
                      selectedDate: selectedDate,
                      onDateSelected: (d) {
                        AppHaptics.selection();
                        setState(() => selectedDate = d);
                      },
                    ),
                    const SizedBox(height: 28),
                    Text("AVAILABLE TIMES (GMT)",
                        style: AppTypography.labelSmall.copyWith(
                            letterSpacing: 1.8,
                            color: AppColors.monoGrey)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        "09:00 AM",
                        "10:30 AM",
                        "01:00 PM",
                        "02:30 PM",
                        "04:00 PM",
                        "05:30 PM"
                      ].map((time) {
                        final isSelected = selectedTime == time;
                        return GestureDetector(
                          onTap: () {
                            AppHaptics.selection();
                            setState(
                                () => selectedTime = time);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.monoBlack
                                  : AppColors.white,
                              border: Border.all(
                                  color:
                                      AppColors.monoDivider),
                            ),
                            child: Text(
                              time,
                              style: AppTypography.bodySmall
                                  .copyWith(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.monoBlack,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SESSION SUMMARY",
                              style: AppTypography.labelSmall
                                  .copyWith(
                                      letterSpacing: 1.8,
                                      color: AppColors.monoGrey)),
                          const SizedBox(height: 12),
                          Text("60 min Consultation",
                              style: AppTypography.heading2
                                  .copyWith(
                                      color: AppColors
                                          .monoBlack)),
                          const SizedBox(height: 4),
                          Text(
                              "with ${stylists[selectedStylist]["name"]}",
                              style: AppTypography.bodyMedium
                                  .copyWith(
                                      color: AppColors
                                          .monoGrey)),
                          const SizedBox(height: 8),
                          Text(
                              "Oct 06, 2024 at ${selectedTime ?? "01:00 PM"}",
                              style: AppTypography.bodySmall
                                  .copyWith(
                                      color: AppColors
                                          .monoGrey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: GestureDetector(
                        onTap: () {
                          AppHaptics.heavy();
                          final stylist =
                              stylists[selectedStylist];
                          context.push('/stylist-chat', extra: {
                            'conversationId':
                                'conv_${stylist["name"]}',
                            'stylistName': stylist["name"]!,
                            'stylistAvatarUrl':
                                stylist["image"]!,
                            'stylistSpecialty':
                                '${stylist["specialty"]} STYLIST',
                          });
                        },
                        child: Container(
                          color: AppColors.monoBlack,
                          alignment: Alignment.center,
                          child: Text("BOOK APPOINTMENT",
                              style: AppTypography.button.copyWith(
                                  color: AppColors.white,
                                  letterSpacing: 2.5)),
>>>>>>> Stashed changes
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(text,
          style: AppTypography.labelSmall.copyWith(letterSpacing: 2, color: AppColors.monoGrey)),
    );
  }

  // ── Stylist carousel ──
  Widget _buildStylistCarousel() {
    return SizedBox(
      height: 340,
      child: PageView.builder(
        controller: _pageCtrl,
        itemCount: _stylists.length,
        onPageChanged: (i) {
          AppHaptics.selection();
          setState(() => _selectedStylist = i);
        },
        itemBuilder: (_, i) {
          final s = _stylists[i];
          final selected = i == _selectedStylist;
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
                _pageCtrl.animateToPage(i, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
                setState(() => _selectedStylist = i);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: selected
                      ? [BoxShadow(color: AppColors.monoBlack.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4))]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: s.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => ShimmerLoading.banner(height: 340),
                        errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Selected indicator
                      if (selected)
                        Positioned(
                          top: 12, right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("SELECTED", style: AppTypography.labelSmall.copyWith(color: AppColors.monoBlack, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      // Info
                      Positioned(
                        left: 20, right: 20, bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.name,
                                style: AppTypography.serif(22, weight: FontWeight.w700, color: AppColors.white)),
                            const SizedBox(height: 4),
                            Text(s.specialty.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(color: AppColors.brass, letterSpacing: 2)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 12, color: AppColors.brass),
                                const SizedBox(width: 4),
                                Text(s.stats,
                                    style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(s.bio, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(color: Colors.white54, height: 1.4)),
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

  // ── Date strip ──
  Widget _buildDateStrip() {
    final days = _nextDays;
    const months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final d = days[i];
          final sel = i == _selectedDayIndex;
          return GestureDetector(
            onTap: () {
              AppHaptics.selection();
              setState(() => _selectedDayIndex = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              decoration: BoxDecoration(
                color: sel ? AppColors.monoBlack : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sel ? AppColors.monoBlack : AppColors.monoDivider),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_weekDays[d.weekday - 1],
                      style: AppTypography.labelSmall.copyWith(
                          color: sel ? Colors.white70 : AppColors.monoGrey,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("${d.day}",
                      style: AppTypography.heading2.copyWith(
                          color: sel ? AppColors.white : AppColors.monoBlack,
                          fontSize: 20)),
                  const SizedBox(height: 2),
                  Text(months[d.month - 1],
                      style: AppTypography.labelSmall.copyWith(
                          color: sel ? Colors.white54 : AppColors.monoGrey, fontSize: 9)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Time grid ──
  Widget _buildTimeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(_times.length, (i) {
          final sel = i == _selectedTimeIndex;
          return GestureDetector(
            onTap: () {
              AppHaptics.selection();
              setState(() => _selectedTimeIndex = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: sel ? AppColors.monoBlack : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sel ? AppColors.monoBlack : AppColors.monoDivider),
              ),
              child: Text(_times[i],
                  style: AppTypography.bodyMedium.copyWith(
                    color: sel ? AppColors.white : AppColors.monoBlack,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  )),
            ),
          );
        }),
      ),
    );
  }

  // ── Session summary ──
  Widget _buildSummary() {
    final s = _stylists[_selectedStylist];
    final d = _nextDays[_selectedDayIndex];
    final time = _selectedTimeIndex >= 0 ? _times[_selectedTimeIndex] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.monoDivider),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: s.imageUrl, width: 56, height: 56, fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(width: 56, height: 56),
                errorWidget: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.monoLightGrey),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("60 min Consultation", style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
                  const SizedBox(height: 2),
                  Text("with ${s.name}", style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                  if (time != null) ...[
                    const SizedBox(height: 4),
                    Text("${_weekDays[d.weekday - 1]} ${d.day}/${d.month} · $time",
                        style: AppTypography.bodySmall.copyWith(color: AppColors.brass, fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.monoLightGrey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.videocam_outlined, size: 18, color: AppColors.monoBlack),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ──
class _Stylist {
  final String name, specialty, stats, imageUrl, bio;
  const _Stylist(this.name, this.specialty, this.stats, this.imageUrl, this.bio);
}

class _CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  const _CalendarWidget({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.monoDivider),
      ),
      child: Column(
        children: [
          Text("October 2024",
              style: AppTypography.heading2.copyWith(
                  color: AppColors.monoBlack)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                .map((d) => Text(d,
                    style: AppTypography.labelSmall.copyWith(
                        color: AppColors.monoGrey)))
                .toList(),
          ),
          const SizedBox(height: 8),
          ...List.generate(4, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (col) {
                  final day = row * 7 + col - 1;
                  if (day < 1 || day > 31) {
                    return const SizedBox(width: 32, height: 32);
                  }
                  final isSelected = day == selectedDate.day;
                  return GestureDetector(
                    onTap: () => onDateSelected(
                        DateTime(2024, 10, day)),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.monoBlack
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text("$day",
                          style: AppTypography.bodySmall.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.monoBlack,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          )),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}
