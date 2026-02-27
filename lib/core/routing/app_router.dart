import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillbridge/features/home/home_screen.dart';
import 'package:skillbridge/features/splash/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppScreens.splashScreen,
  //  redirect: (context, state) {
  //   final isLoggedIn = FirebaseAuth.instance.currentUser != null;
  //   final isAuthRoute = state.matchedLocation == AppScreens.loginScreen
  //                    || state.matchedLocation == AppScreens.registerScreen;

  //   if (!isLoggedIn && !isAuthRoute) return AppScreens.loginScreen;
  //   if (isLoggedIn && isAuthRoute)  return AppScreens.homeScreen;
  //   return null; // مفيش redirect
  // },
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
        return const SignInScreen();
      },
    ),
    GoRoute(
      path: AppScreens.signupScreen,
      builder: (context, state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: AppScreens.forgetPasswordScreen,
      builder: (context, state) {
        return const ForgotPasswordScreen();
      },
    ),
  ],
);
