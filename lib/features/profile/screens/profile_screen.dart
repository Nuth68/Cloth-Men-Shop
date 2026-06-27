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
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
        border: Border.all(color: AppColors.monoDivider, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.monoLightGrey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              return Column(
                children: [
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

          ],
        ),
      ),
    );
  }
}
