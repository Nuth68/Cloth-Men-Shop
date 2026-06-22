import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/wishlist/bloc/wishlist_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => WishlistBloc()),
      ],
      child: MaterialApp.router(
        title: 'StyleThread',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
