// main.dart
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:triptrails/app/architecture/view/admin%20views/home%20screen.dart';
import 'package:triptrails/app/architecture/view/user%20views/user%20home%20screen.dart';
import 'package:triptrails/app/theme/app_colors.dart';

// Define the routes for the application
class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
    '/home',
    '/destinations',
    '/packages',
    '/news',
    '/contact',
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('home'),
        title: 'User Home Screen',
        child: AdminHomePage(),
      ),
    ];
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lavender),
        useMaterial3: true,
      ),
      routerDelegate: BeamerDelegate(
        initialPath: '/home',
        locationBuilder: BeamerLocationBuilder(
          beamLocations: [
            HomeLocation(),
          ],
        ),
      ),
      routeInformationParser: BeamerParser(),
    );
  }
}
