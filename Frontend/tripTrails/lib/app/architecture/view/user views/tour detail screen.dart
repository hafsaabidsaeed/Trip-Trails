import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../login signup/signUp.dart';
import '../login signup/signin.dart';

class TourDetailScreen extends StatefulWidget {
  final Map<String, dynamic> package;

  const TourDetailScreen({Key? key, required this.package}) : super(key: key);

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final String baseUrl = "http://192.168.18.60:5009"; // Base URL for local images

  // Create GlobalKeys for each section
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _destinationsKey = GlobalKey();
  final GlobalKey _packagesKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

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


  @override
  Widget build(BuildContext context) {
    // Get the first image
    String imageUrl = widget.package['images'][0];

    // Check if the image is local or from Cloudinary
    if (!imageUrl.startsWith('http')) {
      imageUrl = '$baseUrl$imageUrl';
    }
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
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/home');
                          scrollToSection(_homeKey);
                        },

                        child: const Text(
                          'Home',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/destinations');
                          scrollToSection(_destinationsKey);
                        },
                        child: const Text(
                          'Destinations',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/packages');
                          scrollToSection(_packagesKey);
                        },
                        child: const Text(
                          'Packages',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/news');
                          scrollToSection(_newsKey);
                        },
                        child: const Text(
                          'News',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/contact');
                          scrollToSection(_contactKey);
                        },
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Image.network(
              imageUrl,
              height: 600,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 120,
                  color: Colors.grey,
                );
              },
            ),

            // Package Name
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        widget.package['title'],
                        style: GoogleFonts.lato(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: AppColors.lavender, size: 40,),
                              SizedBox(width: 8,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    widget.package['location'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                    Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people_outline, color: AppColors.lavender, size: 45,),
                              SizedBox(width: 8,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Package Type',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    widget.package['packageType'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                    Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time_outlined, color: AppColors.lavender, size: 40,),
                              SizedBox(width: 8,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    widget.package['duration'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ), Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.category_outlined, color: AppColors.lavender, size: 40,),
                              SizedBox(width: 5,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Min Age',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '12 +',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '8.0 Superb',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.package['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }
}

