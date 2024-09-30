import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:triptrails/app/architecture/view/login%20signup/signin.dart';
import 'package:triptrails/app/theme/app_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late String name, email, password;
  bool _isObscure = true;


  // Function to make the signup API call
  Future<void> signup(String name, String email, String password) async {
    final url = 'http://192.168.18.60:5009/api/auth/signup';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201 && responseBody.containsKey('token')) {
        if (kDebugMode) {
          print('Signup successful. Token: ${responseBody['token']}');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful! Please sign in.')),
        );

        // Navigate to the sign-in page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } else {
        if (kDebugMode) {
          print('Signup failed: $responseBody');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $responseBody')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Signup error: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Container(
          height: 600,
          width: 600,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white, // Set container background to white
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
                'assets/logo.png',
                height: 100,
                width: 250,
              ),

              const Text(
                'Create Your Account',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // Name, Email, and Password form fields
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      // Name field
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          labelText: 'Name',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Name can't be empty";
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Email field
                      TextFormField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password field
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
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters long";
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

              // Sign Up Button
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

                  icon: const Icon(Icons.person_add, color: Colors.white),

                  label: const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 20),
                  ),

                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Perform sign-up action via API
                      signup(nameCtrl.text, emailCtrl.text, passwordCtrl.text);
                    }
                  },
                ),
              ),

              // Sign In Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign In',
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
