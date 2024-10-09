import 'dart:convert';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
  // final String baseUrl = "http://192.168.100.70:5009"; // Base URL for local images

  late TabController _tabController;

  // Create GlobalKeys for each section
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _destinationsKey = GlobalKey();
  final GlobalKey _packagesKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? _name;
  String? _email;
  String? _phoneNumber;  // Change from int? to String?
  DateTime? _selectedDate;
  String? _selectedTourType;
  String? _selectedTicket;
  int? _numberOfPeople;

  // Sample data for dropdowns
  final List<String> _tourTypes = ['Family', 'Couple', 'Solo'];
  final List<String> _tickets = ['Standard', 'luxury', 'Gold'];
  final List<int> _peopleCount = List.generate(10, (i) => i + 1); // For people count 1 to 10


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare the data for the API request
      Map<String, dynamic> bookingData = {
        'name': _name,
        'email': _email,
        'phoneNumber': '+92 $_phoneNumber',  // Send it as a string with the prefix
        'tourDate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'tourType': _selectedTourType,
        'ticketType': _selectedTicket,
        'numberOfPeople': _numberOfPeople,
        'packageId': widget.package['id'],
      };


      try {
        // Send the POST request to the backend
        final response = await http.post(
          Uri.parse('$baseUrl/api/bookings/add-booking'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(bookingData),
        );

        // Debugging: Print the response
        print('Request URL: $baseUrl/api/bookings/add-booking');
        print('Request Body: ${jsonEncode(bookingData)}');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Clear the form after successful submission
          _formKey.currentState!.reset();

          // Show a success message using a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking successfully submitted!')),
          );
        } else {
          // Handle server error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit booking: ${response.body}')),
          );
        }
      } catch (error) {
        // Handle any error that occurs during the request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
        print('Error occurred: $error');
      }
    }
  }

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

  // Function to pick a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

    final mediaQuery = MediaQuery.of(context); // Access media query
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width ;

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
                    const SizedBox(width: 30), // Space for alignment
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
                padding: const EdgeInsets.symmetric(horizontal: 60),
                height: 85,
                color: Colors.white,
                child: Row(
                  children: [
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
                        // const SizedBox(width: 20),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.lavender,
                                size: 40,
                              ),
                              SizedBox(
                                width: 5,
                              ),
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
                              Icon(
                                Icons.people_outline,
                                color: AppColors.lavender,
                                size: 45,
                              ),
                              SizedBox(
                                width: 5,
                              ),
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
                              Icon(
                                Icons.access_time_outlined,
                                color: AppColors.lavender,
                                size: 40,
                              ),
                              SizedBox(
                                width: 8,
                              ),
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
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.category_outlined,
                                color: AppColors.lavender,
                                size: 40,
                              ),
                              SizedBox(
                                width: 5,
                              ),
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


              // body
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.5 ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Overview',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 15),
                          Container(
                            child: Text(
                                widget.package['description'] ??
                                    'No description available.',
                                style: const TextStyle(fontSize: 18, color: Colors.black54), textAlign: TextAlign.justify,),
                          ),
                          const SizedBox(height: 15),

                          // Included/Exclude Section
                          const Text(
                            'Included/Exclude',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.4,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TabBar like design at the top
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black87,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Basic',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Center(
                                          child: Text(
                                            'Standard',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Center(
                                          child: Text(
                                            'Premium',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Basic Package title and Price
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'BASIC',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'PKR 4,376',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10), // Spacing
                                // Description of the service
                                Text(
                                  'vcyeiwvbc d uiewvbciads  uewbvcowquabc uoebvcouweqabc d \n vequcisb uoevqcb uvecoqbs uvbceq uobecq \n yeifvqc vyieqc ueibqc .',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 10), // Spacing
                                // Delivery time row
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.black45),
                                    SizedBox(width: 8),
                                    Text(
                                      '3 ciqc qecbqx ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30), // Spacing before button

                              ],
                            ),
                          ),


                        ],
                      ),
                    ),

                    SizedBox(width: screenWidth*0.1,),

                    // Booking Form Section
                    Container(
                      width: screenWidth * 0.3 ,
                      decoration: BoxDecoration(
                        color: AppColors.lightlavender,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),

                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      'Book Your Trip',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    // "Name" field (Text Input)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16.0),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _name = value;
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    // "Email" field (Text Input)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16.0),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _email = value;
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        prefixText: '+92 ',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, // Only allow digits
                                        LengthLimitingTextInputFormatter(10),   // Limit to 10 digits
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        if (value.length != 10) {
                                          return 'Phone number must be 10 digits';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _phoneNumber = value;  // Save it as a String
                                      },

                                    ),
                                    SizedBox(height: 20),

                                    // "When" field (Date Picker)
                                    GestureDetector(
                                      onTap: () => _pickDate(context),
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'When',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                              borderSide:
                                                  BorderSide(color: Colors.grey),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 16.0),
                                          ),
                                          controller: TextEditingController(
                                            text: _selectedDate == null
                                                ? ''
                                                : DateFormat('MM/dd/yyyy')
                                                    .format(_selectedDate!),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select a date';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    // "Type" field (Dropdown)
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Type',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16.0),
                                      ),
                                      value: _selectedTourType,
                                      items: _tourTypes.map((type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTourType = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select a tour type';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    // "Ticket" field (Dropdown)
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Choose Ticket',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16.0),
                                      ),
                                      value: _selectedTicket,
                                      items: _tickets.map((ticket) {
                                        return DropdownMenuItem<String>(
                                          value: ticket,
                                          child: Text(ticket),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTicket = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select a ticket';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    // "Number of People" field (Dropdown)
                                    DropdownButtonFormField<int>(
                                      decoration: InputDecoration(
                                        labelText: 'Number of People',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                         contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16.0),
                                      ),
                                      value: _numberOfPeople,
                                      items: _peopleCount.map((count) {
                                        return DropdownMenuItem<int>(
                                          value: count,
                                          child: Text(count.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _numberOfPeople = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select the number of people';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 30),

                                    // "Book Now" button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightlavender,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          const BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      width: screenWidth*0.15,
                                      height: screenHeight*0.07,
                                      child: ElevatedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.lavender, // Color from image
                                          padding: EdgeInsets.symmetric(vertical: 16.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        child: Text(
                                          'BOOK NOW',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold ,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Divider(),
              ),
              SizedBox(height: screenHeight * 0.3,)
            ],

          ),
        ));
  }
}
