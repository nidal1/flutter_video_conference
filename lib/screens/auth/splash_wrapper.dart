import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_conference/core/services/auth_service.dart';
import 'package:flutter_video_conference/screens/auth/login_screen.dart';
import 'package:flutter_video_conference/screens/home/home_screen.dart';

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: StreamBuilder<User?>(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}

class MainContainer extends StatelessWidget {
  final Widget child;
  const MainContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(242, 242, 242, 1),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: child,
    );
  }
}
