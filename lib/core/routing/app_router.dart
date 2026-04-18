import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/core/routing/routing_stream_refresh.dart';
import 'package:skillbridge/core/utils/locator/service_locator.dart';
import 'package:skillbridge/core/utils/services/auth/auth_service.dart';
import 'package:skillbridge/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/home_screen.dart';
import 'package:skillbridge/features/messages/data/models/service_conversation.dart';
import 'package:skillbridge/features/messages/presentation/screens/chat_detail_screen.dart';
import 'package:skillbridge/features/messages/presentation/screens/messages_screen.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';
import 'package:skillbridge/features/post_ad/presentation/screens/post_ad_screen.dart';
import 'package:skillbridge/features/post_ad/presentation/viewModel/ad_posting_cubit.dart';
import 'package:skillbridge/features/product_screen/presentaion/screens/widgets/service_detail_screen.dart';
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
    // == splash Route == //
    GoRoute(
      path: AppScreens.splashScreen,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    // == Auth Routes == //
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

    // == Home Routes == //
    GoRoute(
      path: AppScreens.homeScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const HomeScreen(),
        );
      },
    ),

    // == Post Ad Routes == //
    GoRoute(
      path: AppScreens.postAdScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AdPostingCubit>(),
          child: const PostAdScreen(),
        );
      },
    ),
    GoRoute(
      path: AppScreens.messagesScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<MessagesCubit>()..loadInbox(),
          child: const MessagesScreen(),
        );
      },
    ),
    GoRoute(
      path: AppScreens.chatDetailScreen,
      builder: (context, state) {
        final conversation = state.extra;
        if (conversation is! ServiceConversation) {
          return const Scaffold(
            body: Center(child: Text('Conversation unavailable')),
          );
        }

        return BlocProvider(
          create: (context) =>
              getIt<MessagesCubit>()..loadConversation(conversation),
          child: const ChatDetailScreen(),
        );
      },
    ),
    GoRoute(
      path: AppScreens.ServiceDetailScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const ServiceDetailScreen(),
        );
      },
    ),
  ],
);
