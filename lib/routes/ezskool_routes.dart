import 'package:ezskool/presentation/screens/forgotpasswordscreen.dart';
import 'package:ezskool/presentation/screens/homescreen.dart';
import 'package:ezskool/presentation/screens/loginscreen.dart';
import 'package:ezskool/presentation/screens/signupscreen.dart';
import 'package:ezskool/presentation/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
      ],
    ),
  ],
);

final GoRouter route = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => RegistrationScreen(),
    ),
    GoRoute(
      path: '/forgot_pwd',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
