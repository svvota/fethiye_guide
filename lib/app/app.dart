import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/shell/home_shell.dart';
import '../features/home/home_screen.dart';
import '../features/places/places_screen.dart';
import '../features/place_detail/place_detail_screen.dart';
import '../features/events/events_screen.dart';
import '../features/event_detail/event_detail_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/submit/submit_place_screen.dart';
import '../features/submit/submit_event_screen.dart';
import '../features/admin/admin_review_screen.dart';
// ✅ ADD THIS:
import '../features/debug/debug_tools.dart';

import 'theme.dart';

final localeNotifier = ValueNotifier<Locale?>(null);

class CityGuideApp extends StatelessWidget {
  const CityGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (_, mode, __) {
        return ValueListenableBuilder<Locale?>(
          valueListenable: localeNotifier,
          builder: (_, loc, __) {
            return MaterialApp.router(
              title: 'City Guide',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: mode,
              locale: loc,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('tr')],
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    ShellRoute(
      builder: (_, __, child) => HomeShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/places', builder: (_, __) => const PlacesScreen()),
        GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
        GoRoute(
            path: '/favorites', builder: (_, __) => const FavoritesScreen()),
      ],
    ),
    GoRoute(
        path: '/place/:id',
        builder: (ctx, st) => PlaceDetailScreen(id: st.pathParameters['id']!)),
    GoRoute(
        path: '/event/:id',
        builder: (ctx, st) => EventDetailScreen(id: st.pathParameters['id']!)),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(
        path: '/submit_place', builder: (_, __) => const SubmitPlaceScreen()),
    GoRoute(
        path: '/submit_event', builder: (_, __) => const SubmitEventScreen()),
    GoRoute(path: '/admin', builder: (_, __) => const AdminReviewScreen()),
    // ✅ ADD THIS ROUTE:
    GoRoute(path: '/debug', builder: (_, __) => const DebugTools()),
  ],
);
