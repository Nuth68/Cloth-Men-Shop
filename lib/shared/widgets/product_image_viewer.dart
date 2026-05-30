import 'package:flutter/material.dart';

class ProductImageViewer extends StatelessWidget {
  final String imageUrl;

  const ProductImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Container(
        color: const Color(0xFFEEEEEE),
        child: Center(
          child: Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (_, _, _) => const Icon(Icons.image, size: 64, color: Color(0xFF7A7A7A))),
        ),
      ),
    );
  }
}
