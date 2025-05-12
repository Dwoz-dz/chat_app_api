import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';
import '../../core/config/app_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null) {
      // طلب API لتسجيل الخروج في السيرفر
      await http.post(
        Uri.parse('${AppConfig.apiUrl}/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );
    }

    await prefs.clear(); // حذف التوكن وكل شيء

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم تسجيل الخروج بنجاح'),
          backgroundColor: Colors.deepPurple,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'مرحبًا بك! تم تسجيل الدخول بنجاح',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
