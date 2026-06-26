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
const _kBg = Color(0xFFF2F1EF);
const _kBlack = Color(0xFF0D0D0D);
const _kGrey = Color(0xFFAAAAAA);
const _kDivider = Color(0xFFD8D6D2);
const _kHint = Color(0xFFBBBBBB);
const _kRed = Color(0xFFB94040);

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
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final TextEditingController confirmPassCtrl;

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
    final name = widget.nameCtrl.text.trim();
    final email = widget.emailCtrl.text.trim();
    final password = widget.passCtrl.text;
    final confirm = widget.confirmPassCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          RegisterEvent(name: name, email: email, password: password),
        );
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
              Text('MONOGRAPH', style: _serif(26, w: FontWeight.w400, ls: 6)),
              const SizedBox(height: 2),
              const Divider(color: _kDivider, height: 1),
              const SizedBox(height: 72),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text('CREATE ACCOUNT',
                        style: _serif(26, w: FontWeight.w600, ls: 2.5)),
                    const SizedBox(height: 14),
                    Text(
                      'Join the archive. Fill in the details below.',
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
                    Text('FULL NAME',
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(
                      controller: widget.nameCtrl,
                      hint: 'John Doe',
                    ),
                    const SizedBox(height: 28),
                    Text('EMAIL ADDRESS',
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(
                      controller: widget.emailCtrl,
                      hint: 'archive@monograph.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 28),
                    Text('PASSWORD',
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(
                      controller: widget.passCtrl,
                      hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      obscure: _obscure,
                    ),
                    const SizedBox(height: 28),
                    Text('CONFIRM PASSWORD',
                        style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                    const SizedBox(height: 10),
                    _Field(
                      controller: widget.confirmPassCtrl,
                      hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      obscure: _obscure,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: _kGrey,
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
                    return _BlackBtn(
                      label: loading ? 'CREATING ACCOUNT...' : 'CREATE ACCOUNT',
                      onTap: loading ? null : _register,
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?  ',
                      style: _sans(13, c: const Color(0xFF555555), ls: 0.1)),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Column(
                      children: [
                        Text('SIGN IN',
                            style: _sans(13, w: FontWeight.w700, ls: 0.5)),
                        const SizedBox(height: 1),
                        Container(height: 1, color: _kBlack, width: 60),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Text('GUEST CHECKOUT',
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
  final TextInputType keyboardType;
  final Widget? suffix;

  const _Field({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
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
