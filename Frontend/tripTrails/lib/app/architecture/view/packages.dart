import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html; // Used for file handling in web

class PlacesPage extends StatefulWidget {
  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<dynamic> places = [];
  bool isLoading = true;
  bool isCreating = false; // For loading state while creating a city
  final String apiUrl = 'http://192.168.18.60:5009/api/cities'; // Your API base URL

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('$apiUrl/get-cities'));
    if (response.statusCode == 200) {
      setState(() {
        places = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle creating a new city
  Future<void> createCity(String name, String description, String location, html.File? imageFile) async {
    try {
      setState(() {
        isCreating = true; // Show loading while creating
      });

      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/add-city'));

      // Add fields
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['location'] = location;

      // Attach image file if available
      if (imageFile != null) {
        var reader = html.FileReader();
        reader.readAsDataUrl(imageFile); // Convert file to base64 string
        reader.onLoadEnd.listen((event) async {
          var pic = http.MultipartFile.fromBytes('image', reader.result as List<int>);
          request.files.add(pic);
          final response = await request.send();

          // Handle response
          if (response.statusCode == 201) {
            fetchPlaces();
          } else {
            print("Failed to create city, status code: ${response.statusCode}");
            String responseBody = await response.stream.bytesToString();
            print("Response body: $responseBody");
          }
          setState(() {
            isCreating = false;
          });
        });
      } else {
        final response = await request.send();
        if (response.statusCode == 201) {
          fetchPlaces();
        } else {
          print("Failed to create city, status code: ${response.statusCode}");
        }
        setState(() {
          isCreating = false;
        });
      }
    } catch (error) {
      print("Error occurred while creating city: $error");
      setState(() {
        isCreating = false;
      });
    }
  }

  // Function to delete a city by its ID
  Future<void> deleteCity(String id) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.delete(Uri.parse('$apiUrl/delete-city/$id'));
    if (response.statusCode == 200) {
      fetchPlaces(); // Refresh the list after deletion
    } else {
      print("Failed to delete city");
    }

    setState(() {
      isLoading = false;
    });
  }

  // Function to show the create city form
  void showCreateCityForm(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    html.File? imageFile;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                    uploadInput.accept = 'image/*';
                    uploadInput.click();

                    uploadInput.onChange.listen((e) {
                      final files = uploadInput.files;
                      if (files!.isNotEmpty) {
                        setState(() {
                          imageFile = files.first;
                        });
                      }
                    });
                  },
                  child: Text('Select Image'),
                ),
                imageFile != null
                    ? Image.network(html.Url.createObjectUrl(imageFile!), width: 100, height: 100)
                    : Container(),
                ElevatedButton(
                  onPressed: isCreating
                      ? null
                      : () {
                    if (formKey.currentState!.validate()) {
                      createCity(nameController.text, descriptionController.text,
                          locationController.text, imageFile);
                      Navigator.of(context).pop(); // Close the form after creation
                    }
                  },
                  child: isCreating ? CircularProgressIndicator() : Text('Create City'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: place['image'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'http://192.168.18.60:5009${place['image']}',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image);
                        },
                      ),
                    )
                        : Icon(Icons.location_city),
                    title: Text(place['name']),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start
                      ,
                      children: [
                        Text(place['location']),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteCity(place['_id']),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
