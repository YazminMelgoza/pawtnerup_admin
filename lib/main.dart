import 'package:pawtnerup_admin/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:pawtnerup_admin/config/config.dart';
import 'package:pawtnerup_admin/config/router/app_router.dart';

// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:pawtnerup_admin/provider/location_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp.router(
        title: 'Pawtner Up',
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}