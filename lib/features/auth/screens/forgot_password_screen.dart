import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';

const _kBg = Color(0xFFF2F1EF);
const _kBlack = Color(0xFF0D0D0D);
const _kGrey = Color(0xFFAAAAAA);
const _kDivider = Color(0xFFD8D6D2);
const _kRed = Color(0xFFB94040);
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
      final res = await gql.mutate(
        r'''mutation forgotPassword($email: String!) {
          forgotPassword(email: $email)
        }''',
        variables: {'email': email},
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
        context.push('/reset-password', extra: {'email': email, 'token': ''});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              Text('Steav Fashion', style: _serif(26, w: FontWeight.w400, ls: 6)),
              const SizedBox(height: 2),
              const Divider(color: _kDivider, height: 1),
              const SizedBox(height: 72),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text('FORGOT PASSWORD',
                        style: _serif(26, w: FontWeight.w600, ls: 2.5)),
                    const SizedBox(height: 14),
                    Text(
                      'Enter your email address and we\'ll send you a link to reset your password.',
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
                    Text('EMAIL ADDRESS',
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(controller: _emailCtrl, hint: 'archive@Steav Fashion.com'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BlackBtn(
                  label: _loading ? 'SENDING...' : 'SEND RESET LINK',
                  onTap: _loading ? null : _sendResetLink,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => context.pop(),
                child: Text('BACK TO LOGIN',
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
  const _Field({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: _sans(15, ls: 0.2),
      cursorColor: _kBlack,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: _sans(15, c: _kHint, ls: 0.2),
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
