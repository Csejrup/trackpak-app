import 'dart:async';
import 'package:driver_app/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:shared/presentation/screens/login/login_screen.dart';
import 'package:shared/presentation/screens/splash/splash_screen.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: AppRoutes.splash.path,
      routes: [
        GoRoute(
          path: AppRoutes.splash.path,
          builder:
              (context, state) => SplashScreen(navigateTo: AppRoutes.home.path),
        ),
        GoRoute(
          path: AppRoutes.login.path,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.home.path,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthenticationBloc>().state;
        final isLoggedIn = authState is LoggedIn;
        final isAtLogin = state.matchedLocation == AppRoutes.login.path;

        // If user is NOT logged in, force them to login page
        if (!isLoggedIn) {
          return isAtLogin ? null : AppRoutes.login.path;
        }

        // If user is logged in, redirect to home
        return AppRoutes.home.path;
      },
      refreshListenable: GoRouterRefreshStream(context),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthenticationState> _subscription;

  GoRouterRefreshStream(BuildContext context) {
    /*  _subscription = context.read<AuthenticationBloc>().stream.listen((state) {
      notifyListeners(); // Triggers GoRouter updates when authentication state changes
    }); */
  }

  static GoRouterRefreshStream of(BuildContext context) {
    return context.read<GoRouterRefreshStream>();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
