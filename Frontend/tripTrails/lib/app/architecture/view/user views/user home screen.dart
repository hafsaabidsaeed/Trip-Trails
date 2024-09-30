import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../login signup/signUp.dart';
import '../login signup/signin.dart';
import 'footer.dart';
import 'package:http/http.dart' as http;

import 'aboutUs screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String selectedType = 'Family'; // Default type selection
  DateTime? fromDate; // Store selected From date
  DateTime? toDate; // Store selected To date

  final ScrollController _scrollController = ScrollController();

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


  // List of destinations (images and titles)
  final List<Map<String, String>> destinations = [
    {'title': 'Azad Kashmir', 'image': 'assets/img1.jpg'},
    {'title': 'Gilgit', 'image': 'assets/img2.jpg'},
    {'title': 'Naran Kaghan', 'image': 'assets/img3.jpg'},
    {'title': 'Hunza', 'image': 'assets/img4.jpg'},
    {'title': 'Sawat', 'image': 'assets/img5.jpg', 'subtitle': 'Family'},
  ];

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFrom) {
          fromDate = selectedDate;
        } else {
          toDate = selectedDate;
        }
      });
    }
  }

  List<dynamic> tourPackages = []; // Store the API data
  bool isLoading = true; // Track loading state
  bool hasError = false; // Track error state

  final String baseUrl =
      "http://192.168.18.60:5009"; // Base URL for relative images

  @override
  void initState() {
    super.initState();
    fetchTourPackages(); // Fetch data when the widget is initialized
  }

  Future<void> fetchTourPackages() async {
    const apiUrl = 'http://192.168.18.60:5009/api/cities/get-cities'; // API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tourPackages = data; // Store the API data
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
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
      // Make the body scrollable and maintain central image
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader while fetching data
          : hasError
              ? const Center(
                  child: Text('Failed to load data')) // Error message
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        height:
                            2400, // Fixed height for the entire scrollable content
                        color: Colors.white,
                        child: Stack(
                          children: [
                            // Background image in the body with fixed height of 650
                            Container(
                              key: _homeKey,
                              child: Image.asset(
                                'assets/background1.jpg',
                                height: 650,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  const SizedBox(height: 200),
                                  Image.asset(
                                    'assets/travel.png',
                                    height: 100,
                                    width: 800,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Your journey begins here',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top:
                                  600, // Adjust this value to move the search bar as needed
                              left: 100,
                              right: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Where to (TextField)
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Where to",
                                              style: TextStyle(
                                                color: AppColors.lavender,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                hintText: "Enter keywords",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // When (Date)
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "   From",
                                            style: TextStyle(
                                              color: AppColors.lavender,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _selectDate(context,
                                                  true); // Select From Date
                                            },
                                            child: Text(
                                              fromDate != null
                                                  ? DateFormat('MM/dd/yyyy')
                                                      .format(fromDate!)
                                                  : 'Select From Date   ',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "   To",
                                            style: TextStyle(
                                              color: AppColors.lavender,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _selectDate(context,
                                                  false); // Select To Date
                                            },
                                            child: Text(
                                              toDate != null
                                                  ? DateFormat('MM/dd/yyyy')
                                                      .format(toDate!)
                                                  : 'Select To Date   ',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Type (Dropdown)
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Type",
                                            style: TextStyle(
                                              color: AppColors.lavender,
                                              fontSize: 12,
                                            ),
                                          ),
                                          DropdownButton<String>(
                                            value: selectedType,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'Family',
                                                child: Text('Family'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Solo',
                                                child: Text('Solo'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Couple',
                                                child: Text('Couple'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                selectedType = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      // Find Now Button
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 15,
                                          ),
                                          backgroundColor: AppColors.lavender,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Add search logic here
                                        },
                                        child: const Text(
                                          "FIND NOW",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Positioned text "Go Exotic Places" at the bottom
                            Positioned(
                              top:
                                  750, // Adjust this value to move the search bar as needed
                              left: 100,
                              right: 100,
                              child: Center(
                                child: Container(
                                  key: _destinationsKey,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Exotic Places",
                                        style: GoogleFonts.lato(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Destination lists",
                                        style: TextStyle(
                                          color: AppColors.lavender,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                      // Destination List Grid
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Column(
                                          children: [
                                            // Build rows alternating between 3 and 2 items
                                            for (int i = 0;
                                                i < destinations.length;
                                                i += 5) ...[
                                              // First row with 3 items
                                              Row(
                                                children:
                                                    List.generate(3, (index) {
                                                  if (i + index <
                                                      destinations.length) {
                                                    final destination =
                                                        destinations[i + index];
                                                    return Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                5.0),
                                                        child: Stack(
                                                          children: [
                                                            // Background image
                                                            Container(
                                                              height:
                                                                  250, // Adjust the height as per your design
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      destination[
                                                                          'image']!),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            // Overlay text
                                                            Positioned(
                                                              left: 10,
                                                              bottom: 10,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (destination[
                                                                          'subtitle'] !=
                                                                      null)
                                                                    Text(
                                                                      destination[
                                                                          'subtitle']!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .redAccent,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                      ),
                                                                    ),
                                                                  Text(
                                                                    destination[
                                                                        'title']!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return const SizedBox
                                                      .shrink(); // Empty container if no image
                                                }),
                                              ),
                                              // Second row with 2 items
                                              if (i + 3 < destinations.length)
                                                Row(
                                                  children:
                                                      List.generate(2, (index) {
                                                    if (i + 3 + index <
                                                        destinations.length) {
                                                      final destination =
                                                          destinations[
                                                              i + 3 + index];
                                                      return Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Stack(
                                                            children: [
                                                              // Background image
                                                              Container(
                                                                height:
                                                                    250, // Adjust the height as per your design
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        destination[
                                                                            'image']!),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              // Overlay text
                                                              Positioned(
                                                                left: 10,
                                                                bottom: 10,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    if (destination[
                                                                            'subtitle'] !=
                                                                        null)
                                                                      Text(
                                                                        destination[
                                                                            'subtitle']!,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .redAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    Text(
                                                                      destination[
                                                                          'title']!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return const SizedBox
                                                        .shrink(); // Empty container if no image
                                                  }),
                                                ),
                                            ],
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 70),

                                      Container(
                                        key: _packagesKey,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Popular Tour Packages",
                                              style: GoogleFonts.lato(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Featured Tours",
                                              style: TextStyle(
                                                color: AppColors.lavender,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            // Tour packages List Grid

                                            // Tour packages List Grid
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20.0),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(), // Disable grid scrolling
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3, // 3 items per row
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: 2 /
                                                      2, // Adjust ratio to control height
                                                ),
                                                itemCount: tourPackages.length,
                                                itemBuilder: (context, index) {
                                                  final package = tourPackages[index];

                                                  // Handle both Cloudinary and local images
                                                  String imageUrl =
                                                      package['images'][0];
                                                  if (!imageUrl.startsWith('http')) {
                                                                              // Prepend base URL for local images
                                                    imageUrl = '$baseUrl$imageUrl';
                                                  }
                                                  return Card(
                                                    color: Colors.white,
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(15),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        // Image with favorite icon overlay
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(10),
                                                            topRight:
                                                                Radius.circular(10),
                                                          ),
                                                          child: Image.network(
                                                            imageUrl,
                                                            height: 280,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context,
                                                                error, stackTrace) {
                                                              return const Icon(
                                                                Icons.broken_image,
                                                                size: 120,
                                                                color: Colors.grey,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Rating and superb text
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color:
                                                                        Colors.orange,
                                                                    size: 16,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  Text(
                                                                    '8.0 Superb',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey[700],
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 5),
                                                              // Destination title
                                                              Text(
                                                                package['name'],
                                                                style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5),
                                                              // Location
                                                              Text(
                                                                package['location'],
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add the DiscountSection here
                      Container(
                          key: _newsKey,
                          child: DiscountSection()),
                      // After all content, add the Footer
                      Container(
                          key: _contactKey,
                          child: const Footer()),
                    ],
                  ),
                ),
    );
  }
}
