import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
        final repo = AuthRepository(gql, cache);
        return ProfileBloc(repo)..add(const LoadProfile());
      },
      child: const _EditProfileForm(),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm();
  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() { super.initState(); }
  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, child: Column(children: [
        MonographHeader(onBack: () => context.pop(), onBag: () => context.push('/cart'), onNotification: () => context.push('/notifications'), elevated: true),
        Expanded(
          child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileLoaded) {
              if (_nameCtrl.text.isEmpty) { _nameCtrl.text = state.user.name; _emailCtrl.text = state.user.email; _phoneCtrl.text = state.user.phone ?? ''; }
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(key: _formKey, child: Column(children: [
                const SizedBox(height: 8),
                _buildAvatar(),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.monoDivider, width: 0.5)),
                  child: Column(children: [
                    CustomTextField(label: l10n.translate('fullName'), controller: _nameCtrl, validator: (v) => v == null || v.isEmpty ? l10n.translate('required') : null),
                    const SizedBox(height: 20),
                    CustomTextField(label: l10n.translate('emailAddress'), controller: _emailCtrl, keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return l10n.translate('required'); if (!v.contains('@')) return l10n.translate('invalidEmail'); return null; }),
                    const SizedBox(height: 20),
                    CustomTextField(label: l10n.translate('phoneOptional'), controller: _phoneCtrl, keyboardType: TextInputType.phone),
                  ]),
                ),
                const SizedBox(height: 32),
                CustomButton(label: l10n.translate('saveChanges'), onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  AppHaptics.medium();
                  context.read<ProfileBloc>().add(UpdateProfile(name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.translate('profileUpdated')), backgroundColor: AppColors.monoBlack, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), duration: const Duration(seconds: 2)));
                }),
              ])),
            );
          }),
        ),
      ])),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: GestureDetector(
        onTap: () => AppHaptics.light(),
        child: Stack(children: [
          Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.monoDivider, width: 2)), child: const Padding(padding: EdgeInsets.all(3), child: CircleAvatar(radius: 46, backgroundColor: AppColors.monoLightGrey, child: Icon(Icons.person, size: 44, color: AppColors.monoGrey)))),
          Positioned(bottom: 0, right: 0, child: Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.surface(context), width: 2)), child: Icon(Icons.camera_alt, color: AppColors.surface(context), size: 16))),
        ]),
      ),
    );
  }
}
