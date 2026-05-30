import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
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
                    Text('WELCOME BACK',
                        style: _serif(26, w: FontWeight.w600, ls: 2.5)),
                    const SizedBox(height: 14),
                    Text(
                      'Please enter your credentials to access your archive.',
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
                    _Field(
                      controller: _emailCtrl,
                      hint: 'archive@monograph.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('PASSWORD',
                            style: _sans(10, w: FontWeight.w600, ls: 1.8)),
                        GestureDetector(
                          onTap: () {},
                          child: Text('FORGOT?',
                              style: _sans(10, c: _kRed, w: FontWeight.w600, ls: 1.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _Field(
                      controller: _passCtrl,
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
                child: _BlackBtn(
                  label: 'SIGN IN',
                  onTap: () => context.go('/home'),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: _kDivider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text('OR CONTINUE WITH',
                          style: _sans(9, c: _kGrey, ls: 1.6)),
                    ),
                    const Expanded(child: Divider(color: _kDivider)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 160,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _kBg,
                    border: Border.all(color: _kDivider),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Center(child: _GoogleIcon()),
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?  ",
                      style: _sans(13, c: const Color(0xFF555555), ls: 0.1)),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Column(
                      children: [
                        Text('CREATE ACCOUNT',
                            style: _sans(13, w: FontWeight.w700, ls: 0.5)),
                        const SizedBox(height: 1),
                        Container(height: 1, color: _kBlack, width: 114),
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
  final VoidCallback onTap;
  const _BlackBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          color: _kBlack,
          alignment: Alignment.center,
          child: Text(label,
              style: _sans(13, w: FontWeight.w600, c: Colors.white, ls: 3)),
        ),
      );
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: const Size(26, 26), painter: _GPainter());
}

class _GPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    _arc(canvas, c, r, -20, 100, const Color(0xFF4285F4));
    _arc(canvas, c, r, 80, 130, const Color(0xFFEA4335));
    _arc(canvas, c, r, 210, 90, const Color(0xFFFBBC05));
    _arc(canvas, c, r, 300, 80, const Color(0xFF34A853));

    canvas.drawCircle(c, r * 0.58, Paint()..color = Colors.white);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = r * 0.36
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(c.dx - 0.05, c.dy), Offset(c.dx + r * 0.62, c.dy), barPaint);
  }

  void _arc(Canvas canvas, Offset center, double radius, double startDeg,
      double sweepDeg, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.36;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      _rad(startDeg),
      _rad(sweepDeg),
      false,
      paint,
    );
  }

  double _rad(double deg) => deg * 3.14159265 / 180;

  @override
  bool shouldRepaint(_) => false;
}
