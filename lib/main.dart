import 'package:flutter/material.dart';
import 'package:skillbridge/core/routing/app_router.dart';

void main() {
  runApp(const SkillBridge());
}

class SkillBridge extends StatelessWidget {
  const SkillBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
