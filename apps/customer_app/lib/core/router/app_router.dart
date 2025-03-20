import 'dart:async';
import 'package:customer_app/presentation/screens/home/home_screen.dart';
import 'package:customer_app/presentation/screens/tracking/tracking_details_screen.dart';
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
      debugLogDiagnostics: true,

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
          routes: [
            GoRoute(
              path: '/tracking-details/:orderId/:positionInQueue/:totalOrders',
              name: AppRoutes.trackingDetails.name,
              builder:
                  (context, state) => TrackingDetails(
                    orderId: state.pathParameters['orderId']!,
                    positionInQueue: int.parse(
                      state.pathParameters['positionInQueue']!,
                    ),
                    totalOrders: int.parse(
                      state.pathParameters['totalOrders']!,
                    ),
                  ),
            ),
          ],
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthenticationBloc>().state;
        final isLoggedIn = authState is LoggedIn;
        final isAtLogin = state.matchedLocation == AppRoutes.login.path;

        final path = state.uri.path;
        if (path.startsWith('/home/tracking-details')) {
          return null;
        }

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
