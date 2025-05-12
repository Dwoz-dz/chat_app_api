import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart'; // لازم يكون فيه AppConfig.apiUrl

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse('${AppConfig.apiUrl}/users'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          users = data['users'];
        });
      } else {
        setState(() {
          error = 'فشل في جلب المستخدمين';
        });
      }
    } catch (e) {
      setState(() {
        error = 'خطأ في الاتصال بالخادم';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المستخدمين')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/brp_bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.08,
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                ? Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: fetchUsers,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(user['full_name']),
                        subtitle: Text('اسم المستخدم: ${user['username']}'),
                        trailing: Icon(
                          Icons.circle,
                          color:
                              user['is_online'] == true
                                  ? Colors.green
                                  : Colors.red,
                          size: 12,
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
