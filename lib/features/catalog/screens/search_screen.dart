import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/product_model.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  List<ProductModel> _results = [];
  bool _loading = false;

  String _selectedSize = '';
  String _selectedFit = '';
  String _selectedColor = '';

  final _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final _fits = ['True to Size', 'Runs Small', 'Runs Large'];
  final _colors = ['Black', 'White', 'Navy', 'Grey', 'Brown', 'Beige'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(query));
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _loading = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
      final res = await gql.query(
        r'''query searchProducts($query: String!) {
          searchProducts(query: $query) {
            id name description price imageUrl categoryId sizes colors fit isNew
          }
        }''',
        variables: {'query': query},
      );

      if (res.data != null) {
        final list = res.data!['searchProducts'] as List<dynamic>? ?? [];
        setState(() {
          _results = list
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .where((p) {
            if (_selectedSize.isNotEmpty && !p.sizes.contains(_selectedSize)) return false;
            if (_selectedFit.isNotEmpty && p.fit != _selectedFit) return false;
            if (_selectedColor.isNotEmpty && !p.colors.contains(_selectedColor)) return false;
            return true;
          }).toList();
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reapplyFilters() {
    if (_searchCtrl.text.trim().isNotEmpty) {
      _search(_searchCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          onChanged: _onSearchChanged,
          style: const TextStyle(fontSize: 16, color: Color(0xFF0D0D0D)),
          cursorColor: const Color(0xFF0D0D0D),
          decoration: InputDecoration(
            hintText: 'Search suits, shirts...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D0D0D)),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChipGroup(
                    label: 'Size',
                    options: _sizes,
                    selected: _selectedSize,
                    onSelected: (v) {
                      setState(() => _selectedSize = v);
                      _reapplyFilters();
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChipGroup(
                    label: 'Fit',
                    options: _fits,
                    selected: _selectedFit,
                    onSelected: (v) {
                      setState(() => _selectedFit = v);
                      _reapplyFilters();
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChipGroup(
                    label: 'Color',
                    options: _colors,
                    selected: _selectedColor,
                    onSelected: (v) {
                      setState(() => _selectedColor = v);
                      _reapplyFilters();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(
                        child: Text('No results found',
                            style: TextStyle(color: Color(0xFF888888))),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (_, i) => ProductCard(
                          product: _results[i],
                          onTap: () => context.push('/product-detail',
                              extra: _results[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _FilterChipGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888))),
        ...options.map((opt) {
          final sel = opt == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ChoiceChip(
              label: Text(opt, style: const TextStyle(fontSize: 11)),
              selected: sel,
              onSelected: (_) => onSelected(sel ? '' : opt),
              selectedColor: const Color(0xFF0D0D0D),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: sel ? Colors.white : const Color(0xFF0D0D0D),
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
              ),
              visualDensity: VisualDensity.compact,
            ),
          );
        }),
      ],
    );
  }
}
