import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../architecture/view/login signup/signUp.dart';
import '../architecture/view/login signup/signin.dart';
import '../theme/app_colors.dart';

class UserAppBar extends StatefulWidget {
  const UserAppBar({super.key});

  @override
  State<UserAppBar> createState() => _UserAppBarState();
}

class _UserAppBarState extends State<UserAppBar> {


  // Create GlobalKeys for each section
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _destinationsKey = GlobalKey();
  final GlobalKey _packagesKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();


  // Scroll to the specified key
  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1), // Smooth scrolling
        curve: Curves.easeInOut,
      );
    }
  }

  //Signup Dialog
  void _showSignUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            color: Colors.white,
            width: 500,
            height: 600, // Set dialog size
            child: SignUpPage(), // Use the SignUpPage as a popup form
          ),
        );
      },
    );
  }

  // Login Dialog

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            color: Colors.white,
            width: 500,
            height: 600, // Set dialog size
            child: SignInPage(), // Use the SignInPage as a popup form
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(125),
        child: Column(
          children: [
            // Upper Row: Contact Details
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              color: AppColors.lavender,
              child: Row(
                children: [
                  const SizedBox(width: 27), // Space for alignment
                  const Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.black,
                        size: 16,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '+92 3308113747',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30), // Space between phone and email
                  const Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.black,
                        size: 16,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'info@example.com',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.black,
                          size: 16,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.pinterestP,
                          color: Colors.black,
                          size: 16,
                        ), // Pinterest icon
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.xTwitter,
                          color: Colors.black,
                          size: 16,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.black,
                          size: 16,
                        ), // Instagram icon
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(width: 5), // Space for alignment
                ],
              ),
            ),
            // Lower Row: Logo, Navigation, and Login/Signup Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 85,
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  Image.asset(
                    'assets/logo6.png', // Replace with your logo image path
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => scrollToSection(_homeKey),
                        child: const Text(
                          'Home',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () => scrollToSection(_destinationsKey),
                        child: const Text(
                          'Destinations',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () => scrollToSection(_packagesKey),
                        child: const Text(
                          'Packages',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () => scrollToSection(_newsKey),
                        child: const Text(
                          'News',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () => scrollToSection(_contactKey),
                        child: const Text(
                          'Contact',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showLoginDialog(context);
                        },
                        child: const Text(
                          'Login    /',
                          style: TextStyle(
                              fontSize: 16, color: AppColors.lavender),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showSignUpDialog(context);
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                              fontSize: 16, color: AppColors.lavender),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
