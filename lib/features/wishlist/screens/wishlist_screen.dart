import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

TextStyle _serif(double sz,
    {FontWeight w = FontWeight.w400, Color c = AppColors.monoBlack, double h = 1.2, double ls = 0}) {
  return TextStyle(fontFamily: 'Georgia', fontSize: sz, fontWeight: w, color: c, height: h, letterSpacing: ls);
}

TextStyle _sans(double sz,
    {FontWeight w = FontWeight.w400, Color c = AppColors.monoBlack, double ls = 0.5}) {
  return TextStyle(fontFamily: 'Helvetica Neue', fontSize: sz, fontWeight: w, color: c, letterSpacing: ls);
}

class FavItem {
  final String name;
  final String sub;
  final String price;
  final String imageUrl;

  FavItem({required this.name, required this.sub, required this.price, required this.imageUrl});
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<FavItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      FavItem(
        name: 'Structured Wool\nBlazer',
        sub: 'Noir',
        price: '\$485',
        imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=700&q=85',
      ),
      FavItem(
        name: 'Merino Mock Neck',
        sub: 'Ecru',
        price: '\$175',
        imageUrl: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=700&q=85',
      ),
      FavItem(
        name: 'Pleated Trousers',
        sub: 'Charcoal',
        price: '\$298',
        imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=700&q=85',
      ),
      FavItem(
        name: 'Form Derby Shoe',
        sub: 'Polished Calf',
        price: '\$365',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=700&q=85',
      ),
    ];
  }

  void _remove(int index) => setState(() => _items.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favorites', style: _serif(28, w: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${_items.length} items saved', style: _sans(10, c: AppColors.monoGrey, ls: 0.3)),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.monoDivider, height: 1),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _items.length) return null;
                return _FavCard(item: _items[index], onRemove: () => _remove(index));
              },
              childCount: _items.length,
            ),
          ),
          const SliverToBoxAdapter(child: _RecentSection()),
        ],
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final FavItem item;
  final VoidCallback onRemove;
  const _FavCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.network(item.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: AppColors.monoOffWhite)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: _sans(13, w: FontWeight.w500, ls: 0.3)),
                        const SizedBox(height: 3),
                        Text(item.sub, style: _sans(10, c: AppColors.monoGrey, ls: 0.8)),
                      ],
                    ),
                  ),
                  Text(item.price, style: _sans(13, w: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.monoDivider, height: 1),
            ],
          ),
          Positioned(
            top: 32,
            right: 10,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: AppColors.monoBlack, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection();

  static const _items = [
    _RecentItem(name: 'Silk Scarf', price: '\$110', url: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&q=80'),
    _RecentItem(name: 'Cotton Tee', price: '\$85', url: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Divider(color: AppColors.monoDivider, height: 1),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recently Viewed', style: _serif(20)),
              const SizedBox(height: 16),
              Row(
                children: List.generate(_items.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 0 ? 8 : 0, left: i == 1 ? 8 : 0),
                      child: _RecentCard(item: _items[i]),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _RecentItem {
  final String name, price, url;
  const _RecentItem({required this.name, required this.price, required this.url});
}

class _RecentCard extends StatelessWidget {
  final _RecentItem item;
  const _RecentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.network(item.url, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.monoOffWhite)),
          ),
        ),
        const SizedBox(height: 7),
        Text(item.name, style: _sans(11, w: FontWeight.w500, ls: 0.3)),
        const SizedBox(height: 2),
        Text(item.price, style: _sans(11, c: AppColors.monoGrey, ls: 0.3)),
      ],
    );
  }
}
