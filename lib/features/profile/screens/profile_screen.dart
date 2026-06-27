import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
<<<<<<< Updated upstream
import '../../../core/theme/theme_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/language_bloc.dart';
=======
>>>>>>> Stashed changes
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
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
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
<<<<<<< Updated upstream
            final userName = state is ProfileLoaded ? state.user.name : 'John Doe';
            final userEmail = state is ProfileLoaded ? state.user.email : 'john@example.com';
=======
            final userName =
                state is ProfileLoaded ? state.user.name : 'John Doe';
            final userEmail =
                state is ProfileLoaded ? state.user.email : 'john@example.com';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
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
                      _SettingsGroup(title: 'Appearance', items: [
                        _DarkModeToggle(),
                        _LanguageSelector(),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Support', items: [
                        _SettingItem(icon: Icons.help_outline, label: 'Help Center', onTap: () {}),
                        _SettingItem(icon: Icons.info_outline, label: 'About', onTap: () {}),
=======
                        _SettingItem(
                            icon: Icons.person_outline,
                            label: 'Edit Profile',
                            onTap: () => context.push('/edit-profile')),
                        _SettingItem(
                            icon: Icons.location_on_outlined,
                            label: 'Shipping Addresses',
                            onTap: () => context.push('/address')),
                        _SettingItem(
                            icon: Icons.credit_card_outlined,
                            label: 'Payment Methods',
                            onTap: () => context.push('/payment')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Shopping', items: [
                        _SettingItem(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Orders',
                            onTap: () => context.push('/orders')),
                        _SettingItem(
                            icon: Icons.favorite_outline,
                            label: 'Wishlist',
                            onTap: () => context.push('/wishlist')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Preferences', items: [
                        _SettingItem(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            onTap: () {}),
                        _SettingItem(
                            icon: Icons.lock_outline,
                            label: 'Privacy',
                            onTap: () {}),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: 'Support', items: [
                        _SettingItem(
                            icon: Icons.help_outline,
                            label: 'Help Center',
                            onTap: () {}),
                        _SettingItem(
                            icon: Icons.info_outline,
                            label: 'About',
                            onTap: () {}),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: AppColors.monoDivider, width: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 64, color: AppColors.monoGrey),
                    const SizedBox(height: 20),
                    Text('Welcome to Your Archive',
                        style: AppTypography.heading2.copyWith(
                            color: AppColors.monoBlack),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to access your profile, orders, and saved items.',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.monoGrey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      label: 'SIGN IN',
                      onPressed: () => context.go('/login'),
                    ),
                    const SizedBox(height: 12),
                    CustomButton.outline(
                      label: 'CREATE ACCOUNT',
                      onPressed: () => context.go('/register'),
                    ),
>>>>>>> Stashed changes
                  ],
                ),
              ),
              const SizedBox(height: 24),
<<<<<<< Updated upstream
              const SizedBox(height: 6),
              _SettingsGroup(title: 'Appearance', items: [
                _DarkModeToggle(),
                _LanguageSelector(),
              ]),
              const SizedBox(height: 6),
              _SettingsGroup(title: 'Support', items: [
                _SettingItem(icon: Icons.help_outline, label: 'Help Center', onTap: () {}),
                _SettingItem(icon: Icons.info_outline, label: 'About', onTap: () {}),
=======
              _SettingsGroup(title: 'Support', items: [
                _SettingItem(
                    icon: Icons.help_outline,
                    label: 'Help Center',
                    onTap: () {}),
                _SettingItem(
                    icon: Icons.info_outline,
                    label: 'About',
                    onTap: () {}),
>>>>>>> Stashed changes
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
          if (context.mounted) context.go('/login');
        },
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.monoGrey,
          side: const BorderSide(color: AppColors.monoDivider),
          padding: const EdgeInsets.symmetric(vertical: 14),
<<<<<<< Updated upstream
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
=======
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        borderRadius: BorderRadius.circular(12),
=======
        borderRadius: BorderRadius.circular(4),
>>>>>>> Stashed changes
        border: Border.all(color: AppColors.monoDivider, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.monoLightGrey,
<<<<<<< Updated upstream
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: AppTypography.heading1.copyWith(color: AppColors.monoGrey)),
=======
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTypography.heading1.copyWith(
                color: AppColors.monoGrey,
              ),
            ),
>>>>>>> Stashed changes
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< Updated upstream
                Text(name, style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
                const SizedBox(height: 2),
                Text(email, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
=======
                Text(name,
                    style: AppTypography.heading2.copyWith(
                        color: AppColors.monoBlack)),
                const SizedBox(height: 2),
                Text(email,
                    style: AppTypography.bodySmall.copyWith(
                        color: AppColors.monoGrey)),
>>>>>>> Stashed changes
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/edit-profile'),
            child: const Icon(Icons.edit_outlined,
                color: AppColors.monoGrey, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
<<<<<<< Updated upstream
  final List<Widget> items;
=======
  final List<_SettingItem> items;
>>>>>>> Stashed changes
  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
<<<<<<< Updated upstream
          child: Text(title.toUpperCase(), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
=======
          child: Text(
            title.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              letterSpacing: 1.2,
              color: AppColors.monoGrey,
            ),
          ),
>>>>>>> Stashed changes
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
<<<<<<< Updated upstream
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.monoDivider, width: 0.5),
=======
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: AppColors.monoDivider, width: 0.5),
>>>>>>> Stashed changes
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              return Column(
                children: [
<<<<<<< Updated upstream
                  if (entry.key > 0) const Divider(height: 1, color: AppColors.monoDivider, indent: 16, endIndent: 16),
=======
                  if (entry.key > 0)
                    const Divider(
                        height: 1,
                        color: AppColors.monoDivider,
                        indent: 16,
                        endIndent: 16),
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
class _DarkModeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return InkWell(
      onTap: () => context.read<ThemeCubit>().toggle(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                AppLocalizations.of(context).translate('darkMode'),
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
            ),
            Switch.adaptive(
              value: isDark,
              onChanged: (_) => context.read<ThemeCubit>().toggle(),
              activeTrackColor: isDark ? AppColors.brass : AppColors.monoBlack,
            ),
=======
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
    return InkWell(
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.monoGrey),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.monoBlack)),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.monoGrey),
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }
}
<<<<<<< Updated upstream

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageCubit>().state;
    final langName = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
    }[locale.languageCode] ?? 'English';
    return InkWell(
      onTap: () => _showLanguagePicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.language_outlined, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 14),
            Expanded(
              child: Text('Language', style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary)),
            ),
            Text(langName, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text('Select Language', style: AppTypography.heading2),
              const SizedBox(height: 8),
              _langOption(context, 'English', const Locale('en')),
              _langOption(context, 'Español', const Locale('es')),
              _langOption(context, 'Français', const Locale('fr')),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _langOption(BuildContext context, String label, Locale locale) {
    final active = context.read<LanguageCubit>().state == locale;
    return ListTile(
      title: Text(label),
      trailing: active ? Icon(Icons.check, color: AppColors.textPrimary) : null,
      onTap: () {
        context.read<LanguageCubit>().setLocale(locale);
        Navigator.pop(context);
      },
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
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary))),
            Icon(Icons.chevron_right, size: 20, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
=======
>>>>>>> Stashed changes
