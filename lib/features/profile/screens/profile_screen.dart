import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/language_bloc.dart';
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
      child: _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    // Listen to locale changes so the entire profile page rebuilds when language switches
    final locale = context.watch<LanguageCubit>().state;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: BlocBuilder<ProfileBloc, ProfileState>(
          key: ValueKey('profile_${locale.languageCode}'),
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            if (state is ProfileLoading) {
              return Column(
                children: [
                  MonographHeader(
                    onSearch: () => context.push('/search'),
                    onBag: () => context.push('/cart'),
                    onNotification: () => context.push('/notifications'),
                    elevated: true,
                  ),
                  const Expanded(child: LoadingIndicator()),
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
                MonographHeader(
                  onSearch: () => context.push('/search'),
                  onBag: () => context.push('/cart'),
                  onNotification: () => context.push('/notifications'),
                  elevated: true,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 8),
                      _ProfileCard(name: userName, email: userEmail),
                      const SizedBox(height: 28),
                      _SettingsGroup(title: l10n.translate('account'), items: [
                        _SettingItem(icon: Icons.location_on_outlined, label: l10n.translate('shippingAddress'), onTap: () => context.push('/address')),
                        _SettingItem(icon: Icons.credit_card_outlined, label: l10n.translate('paymentMethods'), onTap: () => context.push('/payment')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: l10n.translate('shopping'), items: [
                        _SettingItem(icon: Icons.shopping_bag_outlined, label: l10n.translate('orders'), onTap: () => context.push('/orders')),
                        _SettingItem(icon: Icons.favorite_outline, label: l10n.translate('wishlist'), onTap: () => context.push('/wishlist')),
                        _SettingItem(icon: Icons.star_outline, label: l10n.translate('reviews'), onTap: () => context.push('/reviews')),
                        _SettingItem(icon: Icons.local_offer_outlined, label: l10n.translate('promotions'), onTap: () => context.push('/promotions')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: l10n.translate('discover'), items: [
                        _SettingItem(icon: Icons.map_outlined, label: l10n.translate('storeLocations'), onTap: () => context.push('/map')),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: l10n.translate('preferences'), items: [
                        _SettingItem(icon: Icons.notifications_outlined, label: l10n.translate('notifications'), onTap: () => context.push('/notifications')),
                        _SettingItem(icon: Icons.lock_outline, label: l10n.translate('privacy'), onTap: () => context.push('/info', extra: _privacyData(l10n))),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: l10n.translate('appearance'), items: [
                        _DarkModeToggle(),
                        _LanguageSelector(),
                      ]),
                      const SizedBox(height: 6),
                      _SettingsGroup(title: l10n.translate('support'), items: [
                        _SettingItem(icon: Icons.help_outline, label: l10n.translate('helpCenter'), onTap: () => context.push('/info', extra: _helpData(l10n))),
                        _SettingItem(icon: Icons.info_outline, label: l10n.translate('about'), onTap: () => context.push('/info', extra: _aboutData(l10n))),
                      ]),
                      const SizedBox(height: 28),
                      _LogoutButton(),
                      const SizedBox(height: 16),
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

  Map<String, String> _privacyData(AppLocalizations l10n) => {'title': l10n.translate('privacy'), 'type': 'privacy'};
  Map<String, String> _helpData(AppLocalizations l10n) => {'title': l10n.translate('helpCenter'), 'type': 'help'};
  Map<String, String> _aboutData(AppLocalizations l10n) => {'title': l10n.translate('about'), 'type': 'about'};

  Widget _buildGuestView(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        MonographHeader(
          onSearch: () => context.push('/search'),
          onBag: () => context.push('/cart'),
          onNotification: () => context.push('/notifications'),
          elevated: true,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.monoDivider, width: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.person_outline, size: 64, color: AppColors.monoGrey),
                    const SizedBox(height: 20),
                    Text(l10n.translate('welcomeArchive'), style: AppTypography.heading2.copyWith(color: Theme.of(context).colorScheme.onSurface), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text(l10n.translate('signInPrompt'), style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey), textAlign: TextAlign.center),
                    const SizedBox(height: 28),
                    CustomButton(label: l10n.translate('signIn'), onPressed: () => context.go('/login')),
                    const SizedBox(height: 12),
                    CustomButton.outline(label: l10n.translate('createAccount'), onPressed: () => context.go('/register')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 6),
              _SettingsGroup(title: l10n.translate('appearance'), items: [
                _DarkModeToggle(),
                _LanguageSelector(),
              ]),
              const SizedBox(height: 6),
              _SettingsGroup(title: l10n.translate('support'), items: [
                _SettingItem(icon: Icons.help_outline, label: l10n.translate('helpCenter'), onTap: () {}),
                _SettingItem(icon: Icons.info_outline, label: l10n.translate('about'), onTap: () {}),
              ]),
              const SizedBox(height: 16),
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
    final l10n = AppLocalizations.of(context);
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
        label: Text(l10n.translate('logout')),
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
        color: AppColors.surface(context),
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
                Text(name, style: AppTypography.heading2.copyWith(color: Theme.of(context).colorScheme.onSurface)),
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
  final List<Widget> items;
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
            color: AppColors.surface(context),
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                AppLocalizations.of(context).translate('darkMode'),
                style: AppTypography.bodyLarge.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Switch.adaptive(
              value: isDark,
              onChanged: (_) => context.read<ThemeCubit>().toggle(),
              activeTrackColor: isDark ? AppColors.brass : AppColors.monoBlack,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageCubit>().state;
    final langName = {
      'km': 'ភាសាខ្មែរ',
      'en': 'English',
    }[locale.languageCode] ?? 'ភាសាខ្មែរ';
    return InkWell(
      onTap: () => _showLanguagePicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.language_outlined, size: 20, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 14),
            Expanded(
              child: Text(AppLocalizations.of(context).translate('language'), style: AppTypography.bodyLarge.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            ),
            Text(langName, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: Theme.of(context).colorScheme.onSurface),
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
              Text(AppLocalizations.of(context).translate('selectLanguage'), style: AppTypography.heading2),
              const SizedBox(height: 8),
              _langOption(context, 'ភាសាខ្មែរ', const Locale('km')),
              _langOption(context, 'English', const Locale('en')),
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
      trailing: active ? Icon(Icons.check, color: Theme.of(context).colorScheme.onSurface) : null,
      onTap: () {
        context.read<LanguageCubit>().setLocale(locale);
        context.pop();
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
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.bodyLarge.copyWith(color: Theme.of(context).colorScheme.onSurface))),
            Icon(Icons.chevron_right, size: 20, color: Theme.of(context).colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
