import 'package:flutter/material.dart';
import 'package:triptrails/app/architecture/view/home%20screen.dart';
import 'package:triptrails/app/architecture/view/signin.dart';
import 'package:triptrails/app/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lavender),
        useMaterial3: true,
      ),
      home: SignInPage(),
    );
  }
}