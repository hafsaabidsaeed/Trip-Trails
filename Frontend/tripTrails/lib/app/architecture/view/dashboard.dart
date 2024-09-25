import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataInfoPage extends StatefulWidget {
  const DataInfoPage({Key? key}) : super(key: key);

  @override
  _DataInfoPageState createState() => _DataInfoPageState();
}

class _DataInfoPageState extends State<DataInfoPage> {
  int totalUsers = 0;
  int totalPlaces = 0;
  int totalPackages = 0;
  bool isLoading = true;

  final String usersApiUrl = 'http://192.168.18.60:5009/api/auth/get-users'; // Users API
  final String placesApiUrl = 'http://192.168.18.60:5009/api/cities/get-cities'; // Places API
  final String packagesApiUrl = 'http://192.168.18.60:5009/api/tour-packages/get-packages'; // Packages API

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch all data when the page loads
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([fetchTotalUsers(), fetchTotalPlaces(), fetchTotalPackages()]);

    setState(() {
      isLoading = false;
    });
  }

  // Fetch total users from the API
  Future<void> fetchTotalUsers() async {
    try {
      final response = await http.get(Uri.parse(usersApiUrl));
      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        setState(() {
          totalUsers = users.length;
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  // Fetch total places from the API
  Future<void> fetchTotalPlaces() async {
    try {
      final response = await http.get(Uri.parse(placesApiUrl));
      if (response.statusCode == 200) {
        List<dynamic> places = json.decode(response.body);
        setState(() {
          totalPlaces = places.length;
        });
      } else {
        print('Failed to load places: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching places: $error');
    }
  }

  // Fetch total tour packages from the API
  Future<void> fetchTotalPackages() async {
    try {
      final response = await http.get(Uri.parse(packagesApiUrl));
      if (response.statusCode == 200) {
        List<dynamic> packages = json.decode(response.body);
        setState(() {
          totalPackages = packages.length;
        });
      } else {
        print('Failed to load packages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching packages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05, top: w * 0.05),
      child: Column(
        children: [
          // Heading
          Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          // Description
          Text(
            'Get a quick summary of the platform\'s key metrics including total users, places, packages, notifications, and more to stay updated on the overall activity and performance of your system.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),

          isLoading
              ? CircularProgressIndicator() // Show loading spinner while fetching data
              : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  card('TOTAL USERS', totalUsers),
                  SizedBox(width: 20),
                  card('TOTAL PLACES', totalPlaces),
                  SizedBox(width: 20),
                  card('TOTAL PACKAGES', totalPackages),
                ],
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  card('TOTAL NOTIFICATIONS', 0), // Placeholder, update if needed
                  SizedBox(width: 20),
                  card('FEATURED ITEMS', 0), // Placeholder, update if needed
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Card widget to display title and number
  Widget card(String title, int number) {
    return Container(
      padding: EdgeInsets.all(30),
      height: 180,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 2,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Icon(
                Icons.trending_up,
                size: 40,
                color: Colors.deepPurpleAccent,
              ),
              SizedBox(width: 5),
              Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
