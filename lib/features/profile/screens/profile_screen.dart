import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
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
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileUnauthenticated) {
              return _buildGuestView(context);
            }
            if (state is ProfileError) {
              return _buildGuestView(context);
            }
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
                      _LogoutButton(),
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

  Widget _buildGuestView(BuildContext context) {
    return Column(
      children: [
        const MonographHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(32),
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
                  children: [
                    Icon(Icons.person_outline, size: 64, color: AppColors.monoGrey),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to Your Archive',
                      style: AppTypography.heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to access your profile, orders, and saved items.',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D0D0D),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.go('/register'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          side: const BorderSide(color: Color(0xFF0D0D0D)),
                        ),
                        child: const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D0D0D),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final cache = CacheService();
          await cache.clearToken();
          context.go('/login');
        },
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