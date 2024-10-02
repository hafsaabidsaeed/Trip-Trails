import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:triptrails/app/architecture/view/user%20views/tour%20detail%20screen.dart';
import '../../../theme/app_colors.dart';

class DisplayTourPackages extends StatefulWidget {
  const DisplayTourPackages({super.key});

  @override
  State<DisplayTourPackages> createState() => _DisplayTourPackagesState();
}

class _DisplayTourPackagesState extends State<DisplayTourPackages> {

  List<dynamic> tourPackages = []; // Store the API data
  bool isLoading = true; // Track loading state
  bool hasError = false; // Track error state
  final String baseUrl = "http://192.168.18.60:5009"; // Base URL for relative images
  // final String baseUrl = "http://192.168.100.70:5009"; // Base URL for relative images

  @override
  void initState() {
    super.initState();
    fetchTourPackages(); // Fetch data when the widget is initialized
  }

  Future<void> fetchTourPackages() async {
    const apiUrl = 'http://192.168.18.60:5009/api/tour-packages/get-packages'; // API URL
    // const apiUrl = 'http://192.168.100.70:5009/api/tour-packages/get-packages'; // API URL
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
    return Container(
     child:  Column(
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(), // Disable grid scrolling
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 2,
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
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailScreen(package: package),
                      ),
                    );

                  },
                  child: Card(
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
                          padding: const EdgeInsets.all(8.0),
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
                                package['title'],
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
                              // Location
                              Text(
                                package['duration'],
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
