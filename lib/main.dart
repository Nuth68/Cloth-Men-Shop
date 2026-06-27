import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:flutter_localizations/flutter_localizations.dart';
=======
>>>>>>> Stashed changes
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
<<<<<<< Updated upstream
import 'core/theme/theme_bloc.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/language_bloc.dart';
=======
>>>>>>> Stashed changes
import 'navigation/app_router.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/wishlist/bloc/wishlist_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
<<<<<<< Updated upstream
    SystemUiOverlayStyle(
=======
    const SystemUiOverlayStyle(
>>>>>>> Stashed changes
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter _router;
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _router = appRouter(navigatorKey: _navigatorKey);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => WishlistBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
      ],
<<<<<<< Updated upstream
      child: _AppView(
        router: _router,
        themeMode: _themeMode,
        locale: _locale,
        onThemeChanged: (mode) => setState(() => _themeMode = mode),
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  final GoRouter router;
  final ThemeMode themeMode;
  final Locale locale;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  const _AppView({
    required this.router,
    required this.themeMode,
    required this.locale,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeCubit, ThemeMode>(
      listener: (_, mode) {
        AppColors.setDarkMode(mode == ThemeMode.dark);
        onThemeChanged(mode);
      },
      child: BlocListener<LanguageCubit, Locale>(
        listener: (_, locale) => onLocaleChanged(locale),
        child: MaterialApp.router(
          title: 'Steav Fashion',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('es'), Locale('fr')],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
=======
      child: MaterialApp.router(
        title: 'MONOGRAPH',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
>>>>>>> Stashed changes
      ),
    );
  }
}
