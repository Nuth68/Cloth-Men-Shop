import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_bottom_sheet.dart';

final List<ProductModel> _products = [
  ProductModel(id: '1', name: 'Structured Wool Blazer', description: 'Premium wool blend with modern tailoring.', price: 485.00,
      imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=700&q=85', categoryId: 'cat_1', isNew: true),
  ProductModel(id: '2', name: 'Merino Mock Neck', description: 'Fine merino wool for effortless layering.', price: 175.00,
      imageUrl: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=700&q=85', categoryId: 'cat_2'),
  ProductModel(id: '3', name: 'Pleated Trousers', description: 'Refined pleated silhouette in wool blend.', price: 298.00,
      imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=700&q=85', categoryId: 'cat_1'),
  ProductModel(id: '4', name: 'Form Derby Shoe', description: 'Polished calfskin derby with structured sole.', price: 365.00,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=700&q=85', categoryId: 'cat_3', isNew: true),
  ProductModel(id: '5', name: 'Cashmere Overcoat', description: 'Double-faced cashmere with peak lapels.', price: 890.00,
      imageUrl: 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=700&q=85', categoryId: 'cat_1'),
  ProductModel(id: '6', name: 'Silk Charmer Scarf', description: 'Hand-rolled silk twill with abstract pattern.', price: 110.00,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=700&q=85', categoryId: 'cat_4'),
  ProductModel(id: '7', name: 'Linen Cotton Shirt', description: 'Breezy linen-cotton poplin for warm days.', price: 195.00,
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=700&q=85', categoryId: 'cat_2'),
  ProductModel(id: '8', name: 'Leather Belt', description: 'Italian full-grain leather with brushed buckle.', price: 145.00,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=700&q=85', categoryId: 'cat_4'),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('SHOP',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black, size: 22),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const FilterBottomSheet(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) => ProductCard(
          product: _products[index],
          onTap: () => context.push('/product-detail', extra: _products[index]),
        ),
      ),
    );
  }
}
