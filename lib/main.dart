import 'package:flutter/material.dart';
import 'pages/onboarding.dart';
import 'widgets/responsive_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if it's available (optional)
  // Uncomment the lines below if you have Firebase configured
  /*
  try {
    import 'package:firebase_core/firebase_core.dart';
    import 'firebase_options.dart';
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase not configured - app will run without it
    if (kDebugMode) {
      print('Firebase not initialized: $e');
    }
  }
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLife - Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        // Wrap all pages with responsive wrapper for web
        if (child == null) return const SizedBox.shrink();
        return ResponsiveWrapper(child: child);
      },
      home: const OnboardingScreen(),
    );
  }
}
