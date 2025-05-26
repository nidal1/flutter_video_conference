import 'package:flutter/material.dart';
import 'package:flutter_video_conference/core/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Sign in with Google"),
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
          },
        ),
      ),
    );
  }
}
