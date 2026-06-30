import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/routing/app_router.dart';
import 'package:skillbridge/core/services/notifications/app_push_service.dart';
import 'package:skillbridge/core/utils/observers/bloc_observer.dart';
import 'package:skillbridge/core/utils/helpers/init_hive.dart';
import 'package:skillbridge/core/utils/locale_cubit.dart';
import 'package:skillbridge/firebase_options.dart';
import 'package:skillbridge/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await ScreenUtil.ensureScreenSize();
  await initHive();
  Bloc.observer = AppBlocObserver();
  setupLocator();
  await getIt<LocaleCubit>().loadLocale();
  await getIt<AppPushService>().initialize();
  runApp(const SkillBridge());
}

class SkillBridge extends StatelessWidget {
  const SkillBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp.router(
              title: 'ServiMarket',
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              locale: locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('ar')],
            ),
          );
        },
      ),
    );
  }
}
