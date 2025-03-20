enum AppRoutes {
  splash,
  login,
  home,
  tracking,
  trackingDetails,
  notifications,
  profile,
  settings,
  help,
  feedback,
  invite,
  terms,
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
      case AppRoutes.tracking:
        return '/tracking';
      case AppRoutes.trackingDetails:
        return '/tracking-details';
      case AppRoutes.notifications:
        return '/notifications';
      case AppRoutes.profile:
        return '/profile';
      case AppRoutes.settings:
        return '/settings';
      case AppRoutes.help:
        return '/help';
      case AppRoutes.feedback:
        return '/feedback';
      case AppRoutes.invite:
        return '/invite';
      case AppRoutes.terms:
        return '/terms';
    }
  }
}
