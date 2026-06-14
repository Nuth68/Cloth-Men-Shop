import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

const _kApiBaseUrl = 'http://10.0.2.2:3000';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrl: _kApiBaseUrl, cache: cache);
        final repo = AuthRepository(gql, cache);
        return ProfileBloc(repo)..add(const LoadProfile());
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.monoOffWhite,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final userName = state is ProfileLoaded ? state.user.name : 'John Doe';
            final userEmail = state is ProfileLoaded ? state.user.email : 'john@example.com';

            return Column(
              children: [
                const MonographHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 8),
                      _ProfileCard(name: userName, email: userEmail),
                      const SizedBox(height: 28),
                      _SettingsGroup(
                        title: 'Account',
                        items: [
                          _SettingItem(
                            icon: Icons.person_outline,
                            label: 'Edit Profile',
                            onTap: () => context.push('/edit-profile'),
                          ),
                          _SettingItem(
                            icon: Icons.location_on_outlined,
                            label: 'Shipping Addresses',
                            onTap: () {},
                          ),
                          _SettingItem(
                            icon: Icons.credit_card_outlined,
                            label: 'Payment Methods',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _SettingsGroup(
                        title: 'Shopping',
                        items: [
                          _SettingItem(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Orders',
                            onTap: () => context.push('/orders'),
                          ),
                          _SettingItem(
                            icon: Icons.favorite_outline,
                            label: 'Wishlist',
                            onTap: () => context.push('/wishlist'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _SettingsGroup(
                        title: 'Preferences',
                        items: [
                          _SettingItem(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            onTap: () {},
                          ),
                          _SettingItem(
                            icon: Icons.lock_outline,
                            label: 'Privacy',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _SettingsGroup(
                        title: 'Support',
                        items: [
                          _SettingItem(
                            icon: Icons.help_outline,
                            label: 'Help Center',
                            onTap: () {},
                          ),
                          _SettingItem(
                            icon: Icons.info_outline,
                            label: 'About',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/login'),
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('Log Out'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.slate,
                            side: const BorderSide(color: AppColors.monoDivider),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.monoLightGrey,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.monoGrey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.heading2),
                const SizedBox(height: 2),
                Text(email, style: AppTypography.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/edit-profile'),
            child: const Icon(Icons.edit_outlined, color: AppColors.monoGrey, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<_SettingItem> items;

  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.monoGrey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  if (idx > 0)
                    const Divider(height: 1, color: AppColors.monoDivider, indent: 16, endIndent: 16),
                  item,
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.slate),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: AppTypography.body),
              ),
              const Icon(Icons.chevron_right, size: 20, color: AppColors.monoGrey),
            ],
          ),
        ),
      ),
    );
  }
}
