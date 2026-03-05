import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/core/routing/routing_stream_refresh.dart';
import 'package:skillbridge/core/utils/locator/service_locator.dart';
import 'package:skillbridge/core/utils/services/firebase_auth_service_repo.dart';
import 'package:skillbridge/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/features/home/home_screen.dart';
import 'package:skillbridge/features/splash/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppScreens.splashScreen,
  redirect: (context, state) {
    final bool isLoggedIn = getIt<AuthService>().currentUser != null;
    final bool isSplash = state.matchedLocation == AppScreens.splashScreen;
    if (isSplash) return null; //to start with splash
    final bool isOnAuthRoute = [
      AppScreens.signinScreen,
      AppScreens.signupScreen,
      AppScreens.forgetPasswordScreen,
    ].contains(state.matchedLocation);

    if (!isLoggedIn && !isOnAuthRoute) return AppScreens.signinScreen;
    if (isLoggedIn && isOnAuthRoute) return AppScreens.homeScreen;
    return null;
  },
  refreshListenable: GoRouterRefreshStream(
    getIt<AuthService>().authStateChanges,
  ),
  routes: <RouteBase>[
    GoRoute(
      path: AppScreens.homeScreen,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppScreens.splashScreen,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppScreens.signinScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const SignInScreen(),
        );
      },
    ),
    GoRoute(
      path: AppScreens.signupScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const SignUpScreen(),
        );
      },
    ),
    GoRoute(
      path: AppScreens.forgetPasswordScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const ForgotPasswordScreen(),
        );
      },
    ),
  ],
);
