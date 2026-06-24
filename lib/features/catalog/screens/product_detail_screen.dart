import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';
import '../../../shared/widgets/rating_stars.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../widgets/size_selector.dart';
import '../widgets/color_selector.dart';
import '../widgets/fit_guide_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Map<String, dynamic>> _reviews = [];
  bool _loadingReviews = false;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final p = widget.product;
    if (p == null) return;

    setState(() => _loadingReviews = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
      final res = await gql.query(
        r'''query reviews($productId: Int!) {
          reviews(productId: $productId) {
            id rating title comment createdAt
            user { name }
          }
        }''',
        variables: {'productId': int.tryParse(p.id) ?? 0},
      );

      if (res.data != null) {
        final list = res.data!['reviews'] as List<dynamic>? ?? [];
        setState(() {
          _reviews = list.map((e) => e as Map<String, dynamic>).toList();
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingReviews = false);
    }
  }

  Future<void> _submitReview(int rating, String title, String comment) async {
    final p = widget.product;
    if (p == null) return;

    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
      final res = await gql.mutate(
        r'''mutation createReview($input: CreateReviewInput!) {
          createReview(createReviewInput: $input) {
            id rating title comment createdAt
            user { name }
          }
        }''',
        variables: {
          'input': {
            'productId': int.tryParse(p.id) ?? 0,
            'rating': rating,
            'title': title,
            'comment': comment,
          },
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
          const SnackBar(content: Text('Review submitted')),
        );
        _fetchReviews();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showAddReviewSheet() {
    int rating = 3;
    final titleCtrl = TextEditingController();
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Write a Review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(5, (i) {
                    final filled = i < rating;
                    return IconButton(
                      icon: Icon(
                        filled ? Icons.star : Icons.star_border,
                        color: const Color(0xFF8B7355),
                      ),
                      onPressed: () => setSheetState(() => rating = i + 1),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final t = titleCtrl.text.trim();
                      final c = commentCtrl.text.trim();
                      if (t.isEmpty || c.isEmpty) return;
                      Navigator.pop(ctx);
                      _submitReview(rating, t, c);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('SUBMIT',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product not found')),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.black),
            onPressed: () {
              context.read<WishlistBloc>().add(AddToWishlist(p));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to wishlist'), duration: Duration(seconds: 1)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 380,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: p.imageUrl.isNotEmpty
                  ? Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox())
                  : const Center(child: Icon(Icons.image, size: 64, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text('NEW ARRIVAL',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
                    ),
                  if (p.isNew) const SizedBox(height: 12),
                  Text(p.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.2)),
                  const SizedBox(height: 8),
                  Text('\$${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(p.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
                  const SizedBox(height: 24),
                  const SizeSelector(),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.push('/size-guide'),
                    child: const Text('Size Guide',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B7355),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                  const SizedBox(height: 20),
                  const ColorSelector(),
                  const SizedBox(height: 20),
                  const FitGuideWidget(),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<WishlistBloc>().add(AddToWishlist(p));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to wishlist'), duration: Duration(seconds: 1)),
                              );
                            },
                            icon: const Icon(Icons.favorite_outline, color: Colors.black),
                            label: const Text('WISHLIST',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.5)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(AddToCart(CartItemModel(
                                id: p.id,
                                product: p,
                                selectedSize: 'M',
                                selectedColor: p.colors.isNotEmpty ? p.colors.first : '',
                              )));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart'), duration: Duration(seconds: 1)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('ADD TO CART',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text('REVIEWS',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  if (_loadingReviews)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Text('No reviews yet',
                        style: TextStyle(color: Colors.grey))
                  else
                    ..._reviews.map((r) => _ReviewCard(review: r)),
                  const SizedBox(height: 16),
                  FutureBuilder<String?>(
                    future: CacheService().getToken(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showAddReviewSheet,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('ADD REVIEW',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final user = review['user'] as Map<String, dynamic>? ?? {};
    final userName = user['name'] as String? ?? 'Anonymous';
    final rating = (review['rating'] as num?)?.toDouble() ?? 0;
    final title = review['title'] as String? ?? '';
    final comment = review['comment'] as String? ?? '';
    final createdAt = review['createdAt'] as String? ?? '';
    final date = createdAt.length >= 10 ? createdAt.substring(0, 10) : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RatingStars(rating: rating, size: 14),
              const Spacer(),
              Text(date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          if (title.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(comment, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
          const SizedBox(height: 4),
          Text(userName,
              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
