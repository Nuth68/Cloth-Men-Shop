import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/monograph_header.dart';

const _kBg = Color(0xFFF2F1EF);
const _kBlack = Color(0xFF0D0D0D);
const _kDivider = Color(0xFFD8D6D2);

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

class SizeGuideScreen extends StatefulWidget {
  const SizeGuideScreen({super.key});
  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  bool _isMale = true;

  static const _maleData = {
    'XS': {'chest': '34-36', 'waist': '28-30', 'hip': '34-36', 'length': '27'},
    'S': {'chest': '36-38', 'waist': '30-32', 'hip': '36-38', 'length': '28'},
    'M': {'chest': '38-40', 'waist': '32-34', 'hip': '38-40', 'length': '29'},
    'L': {'chest': '40-42', 'waist': '34-36', 'hip': '40-42', 'length': '30'},
    'XL': {'chest': '42-44', 'waist': '36-38', 'hip': '42-44', 'length': '31'},
    'XXL': {'chest': '44-46', 'waist': '38-40', 'hip': '44-46', 'length': '32'},
  };

  static const _femaleData = {
    'XS': {'chest': '30-32', 'waist': '23-25', 'hip': '33-35', 'length': '25'},
    'S': {'chest': '32-34', 'waist': '25-27', 'hip': '35-37', 'length': '26'},
    'M': {'chest': '34-36', 'waist': '27-29', 'hip': '37-39', 'length': '27'},
    'L': {'chest': '36-38', 'waist': '29-31', 'hip': '39-41', 'length': '28'},
    'XL': {'chest': '38-40', 'waist': '31-33', 'hip': '41-43', 'length': '29'},
    'XXL': {'chest': '40-42', 'waist': '33-35', 'hip': '43-45', 'length': '30'},
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = _isMale ? _maleData : _femaleData;
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onBack: () => context.pop(),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _GenderTab(label: l10n.translate('male'), selected: _isMale, onTap: () => setState(() => _isMale = true)),
                        const SizedBox(width: 12),
                        _GenderTab(label: l10n.translate('female'), selected: !_isMale, onTap: () => setState(() => _isMale = false)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kDivider),
                      ),
                      child: Column(
                        children: [
                          _TableRow(
                            cells: [
                              _TableCell(l10n.translate('size'), isHeader: true),
                              _TableCell('${l10n.translate('chest')} (in)', isHeader: true),
                              _TableCell('${l10n.translate('waist')} (in)', isHeader: true),
                              _TableCell('${l10n.translate('hip')} (in)', isHeader: true),
                              _TableCell('${l10n.translate('length')} (in)', isHeader: true),
                            ],
                            isHeader: true,
                          ),
                          ...sizes.map((size) {
                            final m = data[size]!;
                            return _TableRow(
                              cells: [
                                _TableCell(size),
                                _TableCell(m['chest']!),
                                _TableCell(m['waist']!),
                                _TableCell(m['hip']!),
                                _TableCell(m['length']!),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(l10n.translate('howToMeasure'), style: _serif(18, w: FontWeight.w600, ls: 2)),
                    const SizedBox(height: 16),
                    _MeasureStep(
                      number: '1',
                      title: l10n.translate('chest'),
                      description: l10n.translate('chestMeasure'),
                    ),
                    _MeasureStep(
                      number: '2',
                      title: l10n.translate('waist'),
                      description: l10n.translate('waistMeasure'),
                    ),
                    _MeasureStep(
                      number: '3',
                      title: l10n.translate('hip'),
                      description: l10n.translate('hipMeasure'),
                    ),
                    _MeasureStep(
                      number: '4',
                      title: l10n.translate('length'),
                      description: l10n.translate('lengthMeasure'),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? _kBlack : Colors.white,
          border: Border.all(color: _kDivider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: _sans(12,
                w: FontWeight.w600,
                c: selected ? Colors.white : _kBlack,
                ls: 2)),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final List<_TableCell> cells;
  final bool isHeader;

  const _TableRow({required this.cells, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _kDivider, width: isHeader ? 2 : 0.5)),
        color: isHeader ? const Color(0xFFF7F6F4) : null,
      ),
      child: Row(
        children: cells.map((c) => Expanded(child: c)).toList(),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isHeader
            ? _sans(10, w: FontWeight.w600, ls: 1.2)
            : _sans(13),
      ),
    );
  }
}

class _MeasureStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _MeasureStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _kBlack,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _sans(14, w: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description,
                    style: _sans(13, c: const Color(0xFF555555), ls: 0.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
