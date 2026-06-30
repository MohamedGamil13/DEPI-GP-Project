import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/core/routing/routing_stream_refresh.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/generated/l10n.dart';
import 'package:skillbridge/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:skillbridge/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/favorites_screen.dart';
import 'package:skillbridge/features/home/presentation/screens/home_screen.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';
import 'package:skillbridge/features/messages/presentation/screens/chat_detail_screen.dart';
import 'package:skillbridge/features/messages/presentation/screens/messages_screen.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/posts/presentation/screens/ad_details_screen.dart';
import 'package:skillbridge/features/posts/presentation/screens/post_ad_screen.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_posting_cubit/ad_posting_cubit.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/user_data_cubit/user_data_cubit.dart';
import 'package:skillbridge/features/profile/data/repos/profile_repo_implementation.dart';
import 'package:skillbridge/features/profile/presentation/screens/profile_screen.dart';
import 'package:skillbridge/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:skillbridge/features/splash/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppScreens.splashScreen,
  redirect: _redirect,
  refreshListenable: GoRouterRefreshStream(
    getIt<AuthService>().authStateChanges,
  ),
  routes: <RouteBase>[
    // == Splash ==
    GoRoute(
      path: AppScreens.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),

    // == Auth ==
    GoRoute(
      path: AppScreens.signinScreen,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const SignInScreen(),
      ),
    ),
    GoRoute(
      path: AppScreens.signupScreen,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      path: AppScreens.forgetPasswordScreen,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const ForgotPasswordScreen(),
      ),
    ),

    // == Home ==
    GoRoute(
      path: AppScreens.homeScreen,
      builder: (context, state) => BlocProvider.value(
        value: getIt<HomeCubit>()..getPosts(),
        child: const HomeScreen(),
      ),
    ),

    // == Favorites ==
    GoRoute(
      path: AppScreens.favoritesScreen,
      builder: (context, state) => BlocProvider.value(
        value: getIt<HomeCubit>()..getPosts(mode: HomeFeedMode.favorites),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(S.of(context).favorites),
          ),
          body: const FavoritesScreen(),
        ),
      ),
    ),

    // == Post Ad ==
    GoRoute(
      path: AppScreens.postAdScreen,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AdPostingCubit>(),
        child: const PostAdScreen(),
      ),
    ),

    // == Profile ==
    GoRoute(
      path: AppScreens.profileScreen,
      builder: (context, state) {
        final userId = state.uri.queryParameters['userId'];
        return BlocProvider(
          create: (_) => ProfileCubit(ProfileRepoImplementation()),
          child: ProfileScreen(userId: userId),
        );
      },
    ),

    // == Messages ==
    // MessagesScreen calls loadInbox(userId) itself in initState,
    // so the cubit is provided here without triggering the load —
    // this keeps the router free of auth state concerns.
    GoRoute(
      path: AppScreens.messagesScreen,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<MessagesCubit>(),
        child: const MessagesScreen(),
      ),
    ),

    // == Chat Detail ==
    // ChatDetailScreen reads the SAME MessagesCubit that MessagesScreen
    // already populated (via BlocProvider.value from the parent route).
    // A new cubit is only created as a fallback when navigating directly
    // to this route (e.g. deep link / notification tap).
    GoRoute(
      path: AppScreens.chatDetailScreen,
      builder: (context, state) {
        final conversation = state.extra is ConversationModel
            ? state.extra as ConversationModel
            : null;
        final conversationId = state.uri.queryParameters['conversationId'];

        if (conversation == null && conversationId == null) {
          return Scaffold(
            body: Center(
              child: Text(AppStrings.conversationUnavailable(context)),
            ),
          );
        }

        final parentCubit = _tryReadCubit<MessagesCubit>(context);
        if (parentCubit != null && conversation != null) {
          return BlocProvider.value(
            value: parentCubit,
            child: const ChatDetailScreen(),
          );
        }

        if (conversation != null) {
          return BlocProvider(
            create: (_) => getIt<MessagesCubit>()
              ..openConversation(
                conversationId: conversation.id,
                currentUserId: getIt<AuthService>().currentUser!.uid,
              ),
            child: const ChatDetailScreen(),
          );
        }

        return FutureBuilder<ConversationModel?>(
          future: getIt<IChatService>().getConversation(conversationId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            }

            final fetchedConversation = snapshot.data;
            if (fetchedConversation == null) {
              return Scaffold(
                body: Center(
                  child: Text(AppStrings.conversationUnavailable(context)),
                ),
              );
            }

            return BlocProvider(
              create: (_) => getIt<MessagesCubit>()
                ..openConversation(
                  conversationId: fetchedConversation.id,
                  currentUserId: getIt<AuthService>().currentUser!.uid,
                ),
              child: const ChatDetailScreen(),
            );
          },
        );
      },
    ),

    // == Ad Details ==
    GoRoute(
      path: AppScreens.adDetailsScreen,
      builder: (context, state) => BlocProvider(
        create: (_) => UserDataCubit(getIt<PostAdRepo>()),
        child: AdDetailsScreen(ad: state.extra as AdModel),
      ),
    ),
  ],
);

/// Safely tries to read [T] from the widget tree without throwing.
T? _tryReadCubit<T extends Object>(BuildContext context) {
  try {
    return context.read<T>();
  } catch (_) {
    return null;
  }
}

String? _redirect(BuildContext context, GoRouterState state) {
  final bool isLoggedIn = getIt<AuthService>().currentUser != null;
  final bool isSplash = state.matchedLocation == AppScreens.splashScreen;

  if (isSplash) return null;

  final bool isOnAuthRoute = [
    AppScreens.signinScreen,
    AppScreens.signupScreen,
    AppScreens.forgetPasswordScreen,
  ].contains(state.matchedLocation);

  if (!isLoggedIn && !isOnAuthRoute) return AppScreens.signinScreen;
  if (isLoggedIn && isOnAuthRoute) return AppScreens.homeScreen;

  return null;
}
