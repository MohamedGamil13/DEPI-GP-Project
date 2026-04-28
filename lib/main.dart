import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/routing/app_router.dart';
import 'package:skillbridge/core/utils/locator/service_locator.dart';
import 'package:skillbridge/core/utils/observers/bloc_observer.dart';
import 'package:skillbridge/core/utils/services/notifications/push_notifications_service.dart';
import 'package:skillbridge/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();
  Bloc.observer = AppBlocObserver();
  setupLocator();
  // getIt<PushNotificationsService>().initFCM();
  PushNotificationsService.initFCM();

  runApp(const SkillBridge());
}

class SkillBridge extends StatelessWidget {
  const SkillBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        title: 'ServiMarket',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
