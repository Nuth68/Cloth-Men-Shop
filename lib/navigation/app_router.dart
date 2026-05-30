import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';
import '../features/catalog/screens/catalog_screen.dart';
import '../features/catalog/screens/product_detail_screen.dart';
import '../data/models/product_model.dart';
import '../data/models/order_model.dart';
import '../features/style_guide/screens/style_guide_screen.dart';
import '../features/wishlist/screens/wishlist_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/checkout/screens/checkout_screen.dart';
import '../features/checkout/screens/address_screen.dart';
import '../features/checkout/screens/payment_screen.dart';
import '../features/orders/screens/orders_screen.dart';
import '../features/orders/screens/order_detail_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/stylist/screens/stylist_booking_screen.dart';
import '../features/stylist/screens/stylist_chat_screen.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
    ShellRoute(
      builder: (_, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(path: '/shop', builder: (_, _) => const CatalogScreen()),
        GoRoute(path: '/lookbook', builder: (_, _) => const LookbookScreen()),
        GoRoute(path: '/stylist', builder: (_, _) => const StylistBookingScreen()),
        GoRoute(path: '/account', builder: (_, _) => const ProfileScreen()),
      ],
    ),
    GoRoute(
      path: '/product-detail',
      builder: (_, state) => ProductDetailScreen(product: state.extra as ProductModel?),
    ),
    GoRoute(path: '/wishlist', builder: (_, _) => const WishlistScreen()),
    GoRoute(path: '/cart', builder: (_, _) => const CartScreen()),
    GoRoute(path: '/checkout', builder: (_, _) => const CheckoutScreen()),
    GoRoute(path: '/address', builder: (_, _) => const AddressScreen()),
    GoRoute(path: '/payment', builder: (_, _) => const PaymentScreen()),
    GoRoute(path: '/orders', builder: (_, _) => const OrdersScreen()),
    GoRoute(
      path: '/order-detail',
      builder: (_, state) => OrderDetailScreen(order: state.extra as OrderModel),
    ),
    GoRoute(path: '/edit-profile', builder: (_, _) => const EditProfileScreen()),
    GoRoute(
      path: '/stylist-chat',
      builder: (_, state) {
        final extra = state.extra as Map<String, String>?;
        return StylistChatScreen(
          conversationId: extra?['conversationId'] ?? 'conv_1',
          stylistName: extra?['stylistName'] ?? 'Elena Vance',
          stylistAvatarUrl: extra?['stylistAvatarUrl'] ?? 'https://i.pravatar.cc/150?u=elena',
          stylistSpecialty: extra?['stylistSpecialty'] ?? 'EXPERT STYLIST',
        );
      },
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final List<NavItem> _items = const [
    NavItem(label: 'Home', icon: Icon(Icons.shopping_bag_outlined)),
    NavItem(label: 'Lookbook', icon: Icon(Icons.menu_book_outlined)),
    NavItem(label: 'Stylist', icon: Icon(Icons.design_services_outlined)),
    NavItem(label: 'Account', icon: Icon(Icons.person_outline)),
  ];

  final List<String> _routes = ['/home', '/lookbook', '/stylist', '/account'];

  int _indexFor(String location) {
    final idx = _routes.indexOf(location);
    return idx >= 0 ? idx : 1;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _indexFor(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: FashionBottomNav(
        selectedIndex: selectedIndex,
        items: _items,
        onTap: (index) => context.go(_routes[index]),
      ),
    );
  }
}
