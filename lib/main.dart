import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'package:flutter/widget_previews.dart';
void main() {
  runApp(const MyApp());
}

@Preview(name: 'rom')
Widget appPreview() => const MyApp();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StyleThread',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
