import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/gender/gender_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/auth/initial_profile_screen.dart';
import '../../features/closet/closet_screen.dart';
import '../../features/closet/models/clothing_item.dart';
import '../../features/closet/add_clothing_screen.dart';
import '../../features/suggestion/outfit_suggestion_screen.dart';
import '../../features/suggestion/saved_outfits_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/calendar/add_event_screen.dart';
import '../../features/settings/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/gender', builder: (context, state) => const GenderScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/otp',
      builder: (context, state) => OtpScreen(phone: state.extra as String? ?? ''),
    ),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/profile/setup', builder: (context, state) => const InitialProfileScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    GoRoute(path: '/closet', builder: (context, state) => const ClosetScreen()),
    GoRoute(
      path: '/closet/add',
      builder: (context, state) => AddClothingScreen(item: state.extra as ClothingItem?),
    ),
    GoRoute(path: '/suggestion', builder: (context, state) => const OutfitSuggestionScreen()),
    GoRoute(path: '/saved-outfits', builder: (context, state) => const SavedOutfitsScreen()),
    GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen()),
    GoRoute(path: '/calendar/add', builder: (context, state) => const AddEventScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
  ],
);
