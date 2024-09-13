import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // For session storage
import 'package:triptrails/app/architecture/view/home%20screen.dart';
import 'package:triptrails/app/architecture/view/signUp.dart';
import 'package:triptrails/app/theme/app_colors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var usernameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late String username, password;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    // Check if session exists when the app starts
    checkSession();
  }

  // Function to check if session token exists
  Future<void> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('session_token');

    if (token != null) {
      // Session exists, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  // Function to handle login and store session
  Future<void> login(String email, String password) async {
    final url = 'http://192.168.18.60:5009/api/auth/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        if (kDebugMode) {
          print('Login successful: $token');
        }

        // Store session token in shared_preferences
        await storeSession(token);

        // Navigate to HomePage on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Login failed: ${errorData['message']}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${errorData['message']}')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
    }
  }

  // Function to store session token using shared_preferences
  Future<void> storeSession(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Container(
          height: 550,
          width: 600,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white, // Set container background color to white
            borderRadius: BorderRadius.circular(15), // Rounded corners
            border: Border.all(
              color: Colors.grey.withOpacity(0.8), // Border color and opacity
              width: 1.5, // Border width
            ),
            boxShadow: [ // Add box shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              // Logo image
              Image.asset(
                'assets/logo.png', // Replace with your logo image path
                height: 110,
                width: 280,
              ),
              const Text(
                'Welcome to Admin Panel',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              // Username and Password form fields
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: usernameCtrl,
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          labelText: 'Username',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Username can't be empty";
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Password can't be empty";
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Sign In Button
              Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Perform sign-in action via API and store session
                      login(usernameCtrl.text, passwordCtrl.text);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Sign Up Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          decorationThickness: 2,
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
    );
  }
}