import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app_clean/features/home/home_screen.dart';
import 'package:chat_app_clean/features/auth/register_screen.dart';
import 'package:chat_app_clean/features/chat/socket_service.dart';
import 'package:chat_app_clean/core/config/app_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _username.text.trim(),
          'password': _password.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('username', data['user']['username']);

        SocketService()
            .connect(); // ما تحتاجش تمرر baseUrl، راه مدمج في service

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          _error = data['message'] ?? 'فشل تسجيل الدخول';
        });
      }
    } catch (e) {
      setState(() {
        _error = '❌ تعذر الاتصال بالخادم';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/brp_bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.08,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 72,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة السر',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child:
                        _loading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('تسجيل الدخول'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
