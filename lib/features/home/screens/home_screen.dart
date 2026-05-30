import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../widgets/hero_section.dart';
import '../widgets/press_banner.dart';
import '../widgets/category_bar.dart';
import '../widgets/new_arrivals_section.dart';
import '../widgets/bestsellers_section.dart';
import '../widgets/philosophy_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MonographHeader(
              onSearch: () {},
              onBag: () => context.push('/cart'),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: HeroSection()),
                  const SliverToBoxAdapter(child: PressBanner()),
                  const SliverToBoxAdapter(child: CategoryBar()),
                  const SliverToBoxAdapter(child: NewArrivalsSection()),
                  const SliverToBoxAdapter(child: BestsellersSection()),
                  const SliverToBoxAdapter(child: PhilosophySection()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
