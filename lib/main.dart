import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'System A&M',
      home: token == null ? const LoginPage(): const HomePage(),
    );
  }
}