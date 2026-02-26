import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/features/home/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppScreens.homeScreen,
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
        return HomeScreen();
      },
    ),
  ],
);
