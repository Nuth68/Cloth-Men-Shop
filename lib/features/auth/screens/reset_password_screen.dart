import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';
import '../../../core/l10n/app_localizations.dart';

const _kBg = Color(0xFFF2F1EF);
const _kBlack = Color(0xFF0D0D0D);
const _kGrey = Color(0xFFAAAAAA);
const _kDivider = Color(0xFFD8D6D2);
const _kHint = Color(0xFFBBBBBB);

TextStyle _serif(double sz,
        {FontWeight w = FontWeight.w400,
        Color c = _kBlack,
        double h = 1.2,
        double ls = 1.0}) =>
    TextStyle(
        fontFamily: 'Georgia',
        fontSize: sz,
        fontWeight: w,
        color: c,
        height: h,
        letterSpacing: ls);

TextStyle _sans(double sz,
        {FontWeight w = FontWeight.w400, Color c = _kBlack, double ls = 0.5}) =>
    TextStyle(
        fontFamily: 'Helvetica Neue',
        fontSize: sz,
        fontWeight: w,
        color: c,
        letterSpacing: ls);

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context);
    final newPass = _newPassCtrl.text;
    final confirmPass = _confirmPassCtrl.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('required'))),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('password'))),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
      final res = await gql.mutate(
        r'''mutation resetPassword($token: String!, $newPassword: String!) {
          resetPassword(token: $token, newPassword: $newPassword)
        }''',
        variables: {
          'token': widget.token,
          'newPassword': newPass,
        },
      );

      if (res.errors != null && res.errors!.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.errors!.first.message)),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translate('profileUpdated'))),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.translate('somethingWentWrong')}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(top: false, 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              Text(l10n.translate('appName'), style: _serif(26, w: FontWeight.w400, ls: 6)),
              const SizedBox(height: 2),
              const Divider(color: _kDivider, height: 1),
              const SizedBox(height: 72),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text(l10n.translate('forgotPassword'),
                        style: _serif(26, w: FontWeight.w600, ls: 2.5)),
                    const SizedBox(height: 14),
                    Text(
                      l10n.translate('password'),
                      textAlign: TextAlign.center,
                      style: _sans(14, c: const Color(0xFF555555), ls: 0.1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.translate('password'),
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(
                      controller: _newPassCtrl,
                      hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      obscure: _obscureNew,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscureNew = !_obscureNew),
                        child: Icon(
                          _obscureNew
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18, color: _kGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(l10n.translate('password'),
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(
                      controller: _confirmPassCtrl,
                      hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      obscure: _obscureConfirm,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        child: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18, color: _kGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BlackBtn(
                  label: _loading ? l10n.translate('signingIn') : l10n.translate('forgotPassword'),
                  onTap: _loading ? null : _resetPassword,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(l10n.translate('signIn'),
                    style: _sans(12, c: const Color(0xFF777777), ls: 1.5)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffix;

  const _Field({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: _sans(15, ls: obscure ? 4 : 0.2),
      cursorColor: _kBlack,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: _sans(15, c: _kHint, ls: 0.2),
        suffixIcon: suffix != null
            ? Padding(padding: const EdgeInsets.only(right: 4), child: suffix)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _kDivider, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _kBlack, width: 1.2),
        ),
        contentPadding: const EdgeInsets.only(bottom: 10),
        isDense: true,
      ),
    );
  }
}

class _BlackBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _BlackBtn({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          color: onTap != null ? _kBlack : _kGrey,
          alignment: Alignment.center,
          child: Text(label,
              style: _sans(13, w: FontWeight.w600, c: Colors.white, ls: 3)),
        ),
      );
}
