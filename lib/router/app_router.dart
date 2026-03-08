import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/sightings_page.dart';
import '../pages/field_guide_page.dart';
import '../pages/news_page.dart';
import '../pages/defense_page.dart';
import '../pages/about_page.dart';
import '../widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/sightings', builder: (context, state) => const SightingsPage()),
        GoRoute(path: '/field-guide', builder: (context, state) => const FieldGuidePage()),
        GoRoute(path: '/news', builder: (context, state) => const NewsPage()),
        GoRoute(path: '/defense', builder: (context, state) => const DefensePage()),
        GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
      ],
    ),
  ],
);
