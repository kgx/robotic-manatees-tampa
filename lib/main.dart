import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

void main() {
  runApp(const RoboticManateesApp());
}

class RoboticManateesApp extends StatelessWidget {
  const RoboticManateesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Robotic Manatees Invade Tampa Bay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
