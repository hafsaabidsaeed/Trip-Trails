import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptrails/app/architecture/view/admin%20views/settings.dart';
import 'package:triptrails/app/architecture/view/login%20signup/signin.dart';
import 'package:triptrails/app/architecture/view/admin%20views/tour_packages.dart';
import 'package:triptrails/app/architecture/view/admin%20views/users%20screen.dart';
import 'package:triptrails/app/theme/app_colors.dart';
import 'package:triptrails/app/widgets/cover widget.dart';
import 'package:triptrails/app/architecture/view/admin%20views/add%20package%20screen.dart';

import 'booking list screen.dart';
import 'dashboard.dart';
import 'locations.dart';



class AdminHomePage extends StatefulWidget {
  AdminHomePage({Key? key}) : super(key: key);
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  PageController _pageController = PageController();

  final List<String> titles = [
    'Dashboard',
    'Tour Packages',
    'Add Packages',
    'Locations',
    'Bookings',
    'Users',
    'Settings',
    'Admin'
  ];

  final List icons = [
    LineIcons.pieChart,
    LineIcons.boxOpen,
    LineIcons.plus,
    LineIcons.mapMarker,
    LineIcons.book,
    LineIcons.users,
    LineIcons.screwdriver,
    LineIcons.user,
  ];

  // Function to handle logout and clear session
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token'); // Clear the session token

    // Navigate back to the SignInPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()), // Go back to the login page
          (Route<dynamic> route) => false, // Remove all routes from stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lavender,
                    fontFamily: 'Muli',
                  ),
                  text: 'Trip Trails',
                  children: <TextSpan>[
                    TextSpan(
                      text: ' - Admin Panel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                        fontFamily: 'Muli',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Logout Button
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF667BC6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    LineIcons.alternateSignOut,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    _logout(); // Call logout function on button press
                  },
                ),
              ),
              const SizedBox(width: 5),
              // Signed-in As Admin Text Button
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF667BC6)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    LineIcons.user,
                    color: Color(0xFF667BC6),
                    size: 20,
                  ),
                  label: const Text(
                    'Signed in as admin ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF667BC6),
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),

      // Body
      body: SafeArea(
        child: Row(
          children: <Widget>[
            // Sidebar
            Container(
              width: 230,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageIndex = index;
                        _pageController.jumpToPage(_pageIndex);
                      });
                    },
                    child: Container(
                      color: _pageIndex == index
                          ? const Color(0xFF667BC6).withOpacity(0.5)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            icons[index],
                            color: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            titles[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Main content area
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                children: <Widget>[
                  DataInfoPage(),
                  CoverWidget(widget: TourPackagesPage()),
                  CoverWidget(widget: AddPackageScreen()),
                  CoverWidget(widget: PlacesPage()),
                  CoverWidget(widget: BookingListScreen()),
                  CoverWidget(widget: UserListScreen()),
                  CoverWidget(widget: AdminSettingsScreen()),
                  const Center(child: Text('Settings')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
