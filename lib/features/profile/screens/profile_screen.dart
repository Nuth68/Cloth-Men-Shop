import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/custom_button.dart';
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
              return const Column(
                children: [
                  MonographHeader(),
                  Expanded(child: LoadingIndicator()),
                ],
              );
            }
            if (state is ProfileUnauthenticated || state is ProfileError) {
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
                      _SettingsGroup(title: 'Account', items: [
                        _SettingItem(icon: Icons.person_outline, label: 'Edit Profile', onTap: () => context.push('/edit-profile')),
                        _SettingItem(icon: Icons.location_on_outlined, label: 'Shipping Addresses', onTap: () => context.push('/address')),
                        _SettingItem(icon: Icons.credit_card_outlined, label: 'Payment Methods', onTap: () => context.push('/payment')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Shopping', items: [
                        _SettingItem(icon: Icons.shopping_bag_outlined, label: 'Orders', onTap: () => context.push('/orders')),
                        _SettingItem(icon: Icons.favorite_outline, label: 'Wishlist', onTap: () => context.push('/wishlist')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Preferences', items: [
                        _SettingItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                        _SettingItem(icon: Icons.lock_outline, label: 'Privacy', onTap: () {}),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Support', items: [
                        _SettingItem(icon: Icons.help_outline, label: 'Help Center', onTap: () {}),
                        _SettingItem(icon: Icons.info_outline, label: 'About', onTap: () {}),
                      ]),
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
                  border: Border.all(color: AppColors.monoDivider, width: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.person_outline, size: 64, color: AppColors.monoGrey),
                    const SizedBox(height: 20),
                    Text('Welcome to Your Archive', style: AppTypography.heading2.copyWith(color: AppColors.monoBlack), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text('Sign in to access your profile, orders, and saved items.', style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey), textAlign: TextAlign.center),
                    const SizedBox(height: 28),
                    CustomButton(label: 'SIGN IN', onPressed: () => context.go('/login')),
                    const SizedBox(height: 12),
                    CustomButton.outline(label: 'CREATE ACCOUNT', onPressed: () => context.go('/register')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SettingsGroup(title: 'Support', items: [
                _SettingItem(icon: Icons.help_outline, label: 'Help Center', onTap: () {}),
                _SettingItem(icon: Icons.info_outline, label: 'About', onTap: () {}),
              ]),
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
          AppHaptics.medium();
          final cache = CacheService();
          await cache.clearToken();
          context.go('/login');
        },
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.monoGrey,
          side: const BorderSide(color: AppColors.monoDivider),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name, email;
  const _ProfileCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.monoDivider, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.monoLightGrey,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: AppTypography.heading1.copyWith(color: AppColors.monoGrey)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
                const SizedBox(height: 2),
                Text(email, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
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
          child: Text(title.toUpperCase(), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.monoDivider, width: 0.5),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              return Column(
                children: [
                  if (entry.key > 0) const Divider(height: 1, color: AppColors.monoDivider, indent: 16, endIndent: 16),
                  entry.value,
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
  const _SettingItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.monoGrey),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.bodyLarge.copyWith(color: AppColors.monoBlack))),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.monoGrey),
          ],
        ),
      ),
    );
  }
}
