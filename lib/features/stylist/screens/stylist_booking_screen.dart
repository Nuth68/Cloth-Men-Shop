import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/monograph_header.dart';

const _black = Color(0xFF111111);
const _grey = Color(0xFF888888);
const _lightGrey = Color(0xFFE8E6E1);
const _bg = Color(0xFFF7F6F4);

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
      "image": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
      "desc": "Ex-editorial director with 15 years experience in bespoke tailoring and personal styling."
    },
    {
      "name": "Elena Rossi",
      "specialty": "Casual Luxe",
      "image": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
      "desc": "Specialist in contemporary luxury casual wear with an eye for effortless silhouettes."
    },
    {
      "name": "Marcus Thorne",
      "specialty": "Archive Pieces",
      "image": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
      "desc": "Expert in vintage and archival fashion, curating one-of-a-kind statement pieces."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
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
                    Text(
                      "SELECT STYLIST",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.8,
                        color: _grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(stylists.length, (index) {
                      final stylist = stylists[index];
                      final isSelected = selectedStylist == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedStylist = index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected ? _black : _lightGrey,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  stylist["image"]!,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 72,
                                    height: 72,
                                    color: _lightGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stylist["name"]!,
                                      style: const TextStyle(
                                        fontFamily: 'Georgia',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: _black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stylist["specialty"]!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: _grey,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      stylist["desc"]!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: _grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.check_circle, color: _black, size: 20),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Text(
                      "SELECT DATE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.8,
                        color: _grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: _lightGrey),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "October 2024",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
                            ].map((d) => Text(
                              d,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _grey,
                              ),
                            )).toList(),
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
                                    onTap: () => setState(() {
                                      selectedDate = DateTime(2024, 10, day);
                                    }),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected ? _black : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        "$day",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected ? Colors.white : _black,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "AVAILABLE TIMES (GMT)",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.8,
                        color: _grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        "09:00 AM", "10:30 AM", "01:00 PM", "02:30 PM", "04:00 PM", "05:30 PM"
                      ].map((time) {
                        final isSelected = selectedTime == time;
                        return GestureDetector(
                          onTap: () => setState(() => selectedTime = time),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? _black : Colors.white,
                              border: Border.all(color: _lightGrey),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : _black,
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
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SESSION SUMMARY",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: _grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "60 min Consultation",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "with ${stylists[selectedStylist]["name"]}",
                            style: TextStyle(
                              fontSize: 14,
                              color: _grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Oct 06, 2024 at ${selectedTime ?? "01:00 PM"}",
                            style: TextStyle(
                              fontSize: 12,
                              color: _grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: GestureDetector(
                        onTap: () {
                          final stylist = stylists[selectedStylist];
                          context.push('/stylist-chat', extra: {
                            'conversationId': 'conv_${stylist["name"]}',
                            'stylistName': stylist["name"]!,
                            'stylistAvatarUrl': stylist["image"]!,
                            'stylistSpecialty': '${stylist["specialty"]} STYLIST',
                          });
                        },
                        child: Container(
                          color: _black,
                          alignment: Alignment.center,
                          child: const Text(
                            "BOOK APPOINTMENT",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
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
