import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedStrings = <String, Map<String, String>>{
    'en': {
      'appName': 'Steav Fashion',
      'home': 'Home',
      'shop': 'Shop',
      'lookbook': 'Lookbook',
      'stylist': 'Stylist',
      'account': 'Account',
      'cart': 'Cart',
      'wishlist': 'Wishlist',
      'orders': 'Orders',
      'checkout': 'Checkout',
      'profile': 'Profile',
      'login': 'Log In',
      'register': 'Create Account',
      'forgotPassword': 'Forgot Password?',
      'logout': 'Log Out',
      'searchHint': 'Search suits, shirts...',
      'newArrivals': 'New Arrivals',
      'addToCart': 'Add to Cart',
      'buyNow': 'Buy Now',
      'total': 'Total',
      'placeOrder': 'Place Order',
      'darkMode': 'Dark Mode',
      'cancelOrder': 'Cancel Order',
      'returnOrder': 'Return Order',
      'sizeGuide': 'Size Guide',
      'reviews': 'Reviews',
    },
    'es': {
      'appName': 'Steav Fashion',
      'home': 'Inicio',
      'shop': 'Tienda',
      'lookbook': 'Catálogo',
      'stylist': 'Estilista',
      'account': 'Cuenta',
      'cart': 'Carrito',
      'wishlist': 'Favoritos',
      'orders': 'Pedidos',
      'checkout': 'Pago',
      'profile': 'Perfil',
      'login': 'Iniciar Sesión',
      'register': 'Crear Cuenta',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'logout': 'Cerrar Sesión',
      'searchHint': 'Buscar trajes, camisas...',
      'newArrivals': 'Nuevos Llegados',
      'addToCart': 'Añadir al Carrito',
      'buyNow': 'Comprar Ahora',
      'total': 'Total',
      'placeOrder': 'Realizar Pedido',
      'darkMode': 'Modo Oscuro',
      'cancelOrder': 'Cancelar Pedido',
      'returnOrder': 'Devolver Pedido',
      'sizeGuide': 'Guía de Tallas',
      'reviews': 'Opiniones',
    },
    'fr': {
      'appName': 'Steav Fashion',
      'home': 'Accueil',
      'shop': 'Boutique',
      'lookbook': 'Catalogue',
      'stylist': 'Styliste',
      'account': 'Compte',
      'cart': 'Panier',
      'wishlist': 'Favoris',
      'orders': 'Commandes',
      'checkout': 'Paiement',
      'profile': 'Profil',
      'login': 'Connexion',
      'register': 'Créer un Compte',
      'forgotPassword': 'Mot de passe oublié?',
      'logout': 'Déconnexion',
      'searchHint': 'Rechercher costumes, chemises...',
      'newArrivals': 'Nouveautés',
      'addToCart': 'Ajouter au Panier',
      'buyNow': 'Acheter',
      'total': 'Total',
      'placeOrder': 'Passer Commande',
      'darkMode': 'Mode Sombre',
      'cancelOrder': 'Annuler la Commande',
      'returnOrder': 'Retourner la Commande',
      'sizeGuide': 'Guide des Tailles',
      'reviews': 'Avis',
    },
  };

  String translate(String key) {
    final langMap = _localizedStrings[locale.languageCode] ?? _localizedStrings['en']!;
    return langMap[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => Future.value(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
