import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  int selectedStylist = 0;
  DateTime selectedDate = DateTime(2024, 10, 6);
  String? selectedTime;

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.monoOffWhite,
      body: SafeArea(
        child: Column(
          children: [
            const MonographHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    BorderRadius.circular(12),
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
