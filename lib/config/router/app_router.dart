import 'package:pawtnerup_admin/app/menu/screen/Pet/pet.dart';
import 'package:pawtnerup_admin/app/menu/screen/location/location.dart';
import 'package:pawtnerup_admin/app/menu/screen/menu_screen.dart';
import 'package:pawtnerup_admin/app/menu/screen/root_menu.dart';
import 'package:pawtnerup_admin/auth/screens/login_screen.dart';
import 'package:pawtnerup_admin/auth/screens/register_screen.dart';
import 'package:pawtnerup_admin/auth/screens/splash_screen.dart';


import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/splash', 
      builder: (context, state) => const SplashScreen()
      ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Menu Route
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),

    GoRoute(path: '/pets', builder: (context, state) => const PetPage()),

    ///* Route App
    GoRoute(
      path: '/Root',
      builder: (context, state) => const RootApp(),
    ),

    ///* Location App
    GoRoute(
      path: '/location',
      builder: (context, state) => const GeolocationApp(),
    ),
  ],
);
