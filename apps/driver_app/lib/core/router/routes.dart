enum AppRoutes {
  splash,
  login,
  home,
  routes,
  routeDetails,
  orderDetails,
  profile,
  settings,
}

extension AppRoutesExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.splash:
        return '/splash';
      case AppRoutes.login:
        return '/login';
      case AppRoutes.home:
        return '/home';
      case AppRoutes.routes:
        return '/routes';
      case AppRoutes.routeDetails:
        return 'home/route-details';
      case AppRoutes.orderDetails:
        return '/orders/details';
      case AppRoutes.profile:
        return '/profile';
      case AppRoutes.settings:
        return '/settings';
    }
  }
}
