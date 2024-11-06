import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello!',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Email: ${user?.email ?? ""}',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/work'),
                child: const Text('Exam 4', style: TextStyle(
                  color: Colors.black
                ),),
              ),
          ],
        ),
      ),
    );
  }
}