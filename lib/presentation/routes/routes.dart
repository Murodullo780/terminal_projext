import 'package:flutter/material.dart';
import 'package:terminal_project/presentation/screens/edit_host/edit_host.dart';
import 'package:terminal_project/presentation/screens/product_catalog/product_catalog.dart';
import 'package:terminal_project/presentation/screens/settings/settings_page.dart';
import 'package:terminal_project/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String editHost = '/edit_host';
  static const String productCatalog = '/productCatalog';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    editHost: (context) => EditHost(),
    productCatalog: (context) => const ProductCatalog(),
    settings: (context) => const SettingsPage(),
  };
}
