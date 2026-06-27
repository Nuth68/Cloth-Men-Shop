import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';
import '../core/theme/theme_bloc.dart';
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
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/catalog/screens/search_screen.dart';
import '../features/catalog/screens/size_guide_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/stylist/screens/stylist_booking_screen.dart';
import '../features/stylist/screens/stylist_chat_screen.dart';
import '../features/onboarding/onboarding_screen.dart';

/// Shared page transition used by most push routes.
CustomTransitionPage<T> _slideFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
    },
  );
}

/// Slide-up transition for product detail (iOS-style modal feel).
CustomTransitionPage<T> _slideUpTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
    },
  );
}

  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/login', pageBuilder: (context, state) => _slideFadeTransition(context: context, state: state, child: const LoginScreen())),
    GoRoute(path: '/register', pageBuilder: (context, state) => _slideFadeTransition(context: context, state: state, child: const RegisterScreen())),

    // ── Shell (bottom nav tabs) ──
    ShellRoute(
      builder: (_, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(path: '/shop', builder: (_, _) => const CatalogScreen()),
        GoRoute(path: '/lookbook', builder: (_, _) => const LookbookScreen()),
        GoRoute(
          path: '/stylist',
          builder: (_, _) => const StylistBookingScreen(),
        ),
        GoRoute(path: '/account', builder: (_, _) => const ProfileScreen()),
      ],
    ),

    // ── Push routes with transitions ──
    GoRoute(
      path: '/product-detail',
      pageBuilder: (context, state) => _slideUpTransition(
        context: context,
        state: state,
        child: ProductDetailScreen(product: state.extra as ProductModel?),
      ),
    ),
    GoRoute(
      path: '/wishlist',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const WishlistScreen(),
      ),
    ),
    GoRoute(
      path: '/cart',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const CartScreen(),
      ),
    ),
    GoRoute(
      path: '/checkout',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const CheckoutScreen(),
      ),
    ),
    GoRoute(
      path: '/address',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const AddressScreen(),
      ),
    ),
    GoRoute(
      path: '/payment',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const PaymentScreen(),
      ),
    ),
    GoRoute(
      path: '/orders',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const OrdersScreen(),
      ),
    ),
    GoRoute(
      path: '/order-detail',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: OrderDetailScreen(order: state.extra as OrderModel),
      ),
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: const EditProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/stylist-chat',
      pageBuilder: (context, state) => _slideFadeTransition(
        context: context,
        state: state,
        child: (() {
          final extra = state.extra as Map<String, String>?;
          return StylistChatScreen(
            conversationId: extra?['conversationId'] ?? 'conv_1',
            stylistName: extra?['stylistName'] ?? 'Elena Vance',
            stylistAvatarUrl:
                extra?['stylistAvatarUrl'] ?? 'https://i.pravatar.cc/150?u=elena',
            stylistSpecialty:
                extra?['stylistSpecialty'] ?? 'EXPERT STYLIST',
          );
        })(),
      ),
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
    NavItem(
      label: 'Home',
    ),
  ];

  final List<String> _routes = [
    '/home',
    '/lookbook',
    '/stylist',
    '/account',
  ];

  int _indexFor(String location) {
    final idx = _routes.indexOf(location);
    return idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild on theme change so cached routes use correct AppColors
    context.select<ThemeCubit, ThemeMode>((c) => c.state);
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _indexFor(location);

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: FashionBottomNav(
        selectedIndex: selectedIndex,
        items: _items,
        onTap: (index) => context.go(_routes[index]),
      ),
    );
  }
}
