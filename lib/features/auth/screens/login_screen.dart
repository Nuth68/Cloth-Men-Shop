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
import '../../../core/utils/haptics.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  bool _obscure = true;
  String? _emailError;
  String? _passError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.go('/home');
    } else if (state is AuthFailure) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _login() {
    setState(() {
      _emailError = _emailCtrl.text.trim().isEmpty ? 'Required' : null;
      _passError = _passCtrl.text.isEmpty ? 'Required' : null;
    });
    if (_emailError != null || _passError != null) return;
    AppHaptics.medium();
    setState(() => _isLoading = true);
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
        final repo = AuthRepository(gql, cache);
        _authBloc = AuthBloc(repo);
        return _authBloc!;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthState,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo ──
                      const SizedBox(height: 40),
                      // ── Email ──
                      _label('Email'),
                      const SizedBox(height: 8),
                      _field(
                        controller: _emailCtrl,
                        focusNode: _emailFocus,
                        hint: 'you@example.com',
                        error: _emailError,
                        onChanged: (_) {
                          if (_emailError != null) setState(() => _emailError = null);
                        },
                        onSubmitted: (_) => _passFocus.requestFocus(),
                      ),
                      if (_emailError != null) _error(_emailError!),
                      const SizedBox(height: 24),
                      // ── Password ──
                      _label('Password'),
                      const SizedBox(height: 8),
                      _field(
                        controller: _passCtrl,
                        focusNode: _passFocus,
                        hint: '········',
                        obscure: _obscure,
                        error: _passError,
                        onChanged: (_) {
                          if (_passError != null) setState(() => _passError = null);
                        },
                        onSubmitted: (_) => _login(),
                        suffix: GestureDetector(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if (_passError != null) _error(_passError!),
                      const SizedBox(height: 36),
                      // ── Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade400,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontFamily: 'Helvetica Neue',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      // ── Links ──
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: const Text(
                              'Create account',
                              style: TextStyle(
                                fontFamily: 'Helvetica Neue',
                                fontSize: 13,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.go('/home'),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontFamily: 'Helvetica Neue',
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'Helvetica Neue',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    bool obscure = false,
    String? error,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontFamily: 'Helvetica Neue',
        fontSize: 16,
        color: Colors.black,
        letterSpacing: 0.2,
      ),
      cursorColor: Colors.black,
      cursorWidth: 1,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Helvetica Neue',
          fontSize: 16,
          color: Color(0xFFCCCCCC),
        ),
        suffixIcon: suffix,
        suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderSide: error != null
              ? const BorderSide(color: Color(0xFFCC3333), width: 1)
              : BorderSide.none,
        ),
        ),
        isDense: true,
      ),
    );
  }

  Widget _error(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Helvetica Neue',
          fontSize: 11,
          color: Color(0xFFCC3333),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
