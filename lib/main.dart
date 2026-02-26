import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/routing/app_router.dart';
import 'package:skillbridge/core/utils/locator/service_locator.dart';
import 'package:skillbridge/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(const SkillBridge());
}

class SkillBridge extends StatelessWidget {
  const SkillBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
