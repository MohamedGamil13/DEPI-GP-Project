import 'package:flutter/material.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextButton(
              onPressed: () {
                context.goAddPost();
              },
              child: const Text('PressMe'),
            ),
          ],
        ),
      ),
    );
  }
}
