import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/animated_list_item.dart';
import '../../../shared/widgets/steav_fashion_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
        final repo = AuthRepository(gql, cache);
        return AuthBloc(repo);
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: _RegisterForm(
          nameCtrl: _nameCtrl,
          emailCtrl: _emailCtrl,
          passCtrl: _passCtrl,
          confirmPassCtrl: _confirmPassCtrl,
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  final TextEditingController nameCtrl, emailCtrl, passCtrl, confirmPassCtrl;
  const _RegisterForm({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.confirmPassCtrl,
  });
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  bool _obscure = true;

  void _register() {
    final l10n = AppLocalizations.of(context);
    final name = widget.nameCtrl.text.trim();
    final email = widget.emailCtrl.text.trim();
    final password = widget.passCtrl.text;
    final confirm = widget.confirmPassCtrl.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('pleaseFillAllFields'))),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('passwordsDoNotMatch'))),
      );
      return;
    }
    context
        .read<AuthBloc>()
        .add(RegisterEvent(name: name, email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              SteavFashionLogo.medium(),
              const SizedBox(height: 2),
              const Divider(color: AppColors.monoDivider, height: 1),
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: AnimatedColumn(
                  children: [
                    Text(l10n.translate('createAccount'),
                        style: AppTypography.displayMedium.copyWith(
                            letterSpacing: 2.5)),
                    const SizedBox(height: 14),
                    Text(
                      l10n.translate('theArchive'),
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF555555), letterSpacing: 0.1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedColumn(
                  children: [
                    CustomTextField(
                        label: l10n.translate('fullName'),
                        hint: l10n.translate('fullNameHint'),
                        controller: widget.nameCtrl),
                    const SizedBox(height: 28),
                    CustomTextField(
                        label: l10n.translate('email'),
                        hint: l10n.translate('emailHint'),
                        controller: widget.emailCtrl,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 28),
                    CustomTextField(
                        label: l10n.translate('password'),
                        hint: l10n.translate('passwordHint'),
                        controller: widget.passCtrl,
                        obscure: _obscure),
                    const SizedBox(height: 28),
                    CustomTextField(
                      label: l10n.translate('password'),
                      hint: l10n.translate('passwordHint'),
                      controller: widget.confirmPassCtrl,
                      obscure: _obscure,
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.monoGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;
                    return AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: loading
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: CustomButton(
                        label: l10n.translate('createAccount'),
                        onPressed: _register,
                      ),
                      secondChild: CustomButton(
                        label: l10n.translate('signingIn'),
                        isLoading: true,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.translate('alreadyHaveAccount'),
                      style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF555555),
                          letterSpacing: 0.1)),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Column(
                      children: [
                        Text(l10n.translate('signIn'),
                            style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                        const SizedBox(height: 1),
                        Container(
                            height: 1,

                            width: 60),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Text(l10n.translate('guestCheckout'),
                    style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF777777),
                        letterSpacing: 1.5)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
