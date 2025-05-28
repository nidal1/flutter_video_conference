import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_conference/screens/auth/splash_wrapper.dart';
import 'package:flutter_video_conference/screens/home/home_screen.dart';
import 'package:flutter_video_conference/screens/home/meeting_screen.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// GoRouter instance
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashWrapper()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/meeting/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId']!;
        return MeetingScreen(meetingId: meetingId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Video App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(242, 242, 242, 1),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
