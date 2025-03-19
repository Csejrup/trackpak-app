import 'package:driver_app/core/router/app_router.dart';
import 'package:driver_app/presentation/blocs/tracking_bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared/core/theme/theme.dart';
import 'package:shared/presentation/blocs/api_bloc/api_bloc.dart';
import 'package:shared/presentation/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:shared/providers/providers.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthenticationBloc(
                secureStorage: SecureStorageProvider(),
                auth0Domain: 'trackpak.eu.auth0.com',
                auth0ClientId: 'Xqm9dCrzLRUb1ONgfu6Dpdb9HgqzuDFg',
              )..add(AuthInit()),
        ),
        BlocProvider(create: (context) => ApiBloc(apiProvider: ApiProvider())),
        BlocProvider(create: (context) => TrackingBloc()),
        ChangeNotifierProvider(
          create: (context) => GoRouterRefreshStream(context),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme().theme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.createRouter(context),
      ),
    );
  }
}
