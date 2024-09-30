import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/app_colors.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2C2E43), // Background color for footer
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Column: Logo and Contact Info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and brief description
                    Row(
                      children: [
                        // Replace with your logo image
                        Image.asset(
                          'assets/logo2.png',
                          height: 80,
                          width: 250,
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to our Trip and Tour Agency.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    // Contact Information
                    Row(
                      children: const [
                        Icon(Icons.phone, color: Colors.orange, size: 16),
                        SizedBox(width: 10),
                        Text('+ 92 330811 3747', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.email, color: Colors.orange, size: 16),
                        SizedBox(width: 10),
                        Text('help@triptrails.com', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.orange, size: 16),
                        SizedBox(width: 10),
                        Text('Phase 4, Defence Lahore', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              // Second Column: Company Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('About Us', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Community Blog', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Rewards', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Work with Us', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Meet the Team', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              // Third Column: Explore Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Explore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Account', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Legal', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Contact', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Affiliate Program', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    Text('Privacy Policy', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              // Fourth Column: Newsletter Subscription
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Newsletter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lavender,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('SUBSCRIBE', style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                          activeColor: AppColors.lavender,
                        ),
                        const Expanded(
                          child: Text(
                            'I agree to all terms and policies',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          // Copyright section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '@ All Copyright 2024, TripTrails',
                style: TextStyle(color: Colors.grey),
              ),
              // Social media icons
              Row(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blueAccent),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.pinterest, color: Colors.redAccent),  // Pinterest icon
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.pinkAccent),  // Instagram icon
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
