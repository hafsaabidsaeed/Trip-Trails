import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart'; // Used for file handling in web

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

  // Unified form to handle both creating and updating a city
  void showCityForm({
    required BuildContext context,
    String? id, // If null, it's create mode, otherwise update
    String? existingName,
    String? existingDescription,
    String? existingLocation,
    List<String>? existingImages, // Accept the existing images for the city
  }) {
    final nameController = TextEditingController(text: existingName ?? '');
    final descriptionController = TextEditingController(text: existingDescription ?? '');
    final locationController = TextEditingController(text: existingLocation ?? '');
    html.File? newImageFile;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(id == null ? 'Create City' : 'Update City'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Display existing images if available
                  if (existingImages != null && existingImages.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Existing Images:'),
                        const SizedBox(height: 10),
                        Wrap(
                          children: existingImages.map((imageUrl) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                imageUrl.startsWith('http')
                                    ? imageUrl
                                    : 'http://192.168.18.60:5009$imageUrl',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                      uploadInput.accept = 'image/*';
                      uploadInput.click();

                      uploadInput.onChange.listen((e) {
                        final files = uploadInput.files;
                        if (files!.isNotEmpty) {
                          setState(() {
                            newImageFile = files.first;
                          });
                        }
                      });
                    },
                    child: const Text('Select New Image'),
                  ),

                  // Display selected new image preview
                  if (newImageFile != null)
                    Image.network(
                      html.Url.createObjectUrl(newImageFile!),
                      width: 100,
                      height: 100,
                    ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (id == null) {
                    createCity(
                      nameController.text,
                      descriptionController.text,
                      locationController.text,
                      newImageFile,
                    );
                  } else {
                    updateCity(
                      id,
                      nameController.text,
                      descriptionController.text,
                      locationController.text,
                      newImageFile, // If no new image selected, the existing images will remain
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  Future<void> createCity(
      String name,
      String description,
      String location,
      html.File? imageFile,
      ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/add-city'));

      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['location'] = location;

      if (imageFile != null) {
        var reader = html.FileReader();
        reader.readAsArrayBuffer(imageFile); // Read as ArrayBuffer to get raw binary data
        reader.onLoadEnd.listen((event) async {
          var bytes = reader.result as List<int>;
          var multipartFile = http.MultipartFile.fromBytes(
            'images',
            bytes,
            filename: imageFile.name,
            contentType: MediaType('image', 'jpeg'), // Adjust content type accordingly
          );

          request.files.add(multipartFile);
          final response = await request.send();

          if (response.statusCode == 201) {
            fetchPlaces();
          } else {
            print('Failed to create city. Status code: ${response.statusCode}');
          }
        });
      } else {
        final response = await request.send();
        if (response.statusCode == 201) {
          fetchPlaces();
        } else {
          print('Failed to create city without image. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print("Error occurred while creating city: $error");
    }
  }

  Future<void> updateCity(
      String id,
      String name,
      String description,
      String location,
      html.File? imageFile,
      ) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/update-city/$id'));

      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['location'] = location;

      if (imageFile != null) {
        var reader = html.FileReader();
        reader.readAsArrayBuffer(imageFile); // Read as ArrayBuffer to get raw binary data
        reader.onLoadEnd.listen((event) async {
          var bytes = reader.result as List<int>;
          var multipartFile = http.MultipartFile.fromBytes(
            'images',
            bytes,
            filename: imageFile.name,
            contentType: MediaType('image', 'jpeg'), // Adjust content type accordingly
          );

          request.files.add(multipartFile);
          final response = await request.send();

          if (response.statusCode == 200) {
            fetchPlaces();
          } else {
            print("Failed to update city. Status code: ${response.statusCode}");
          }
        });
      } else {
        final response = await request.send();
        if (response.statusCode == 200) {
          fetchPlaces();
        } else {
          print("Failed to update city without image. Status code: ${response.statusCode}");
        }
      }
    } catch (error) {
      print("Error occurred while updating city: $error");
    }
  }

  Future<void> deleteCity(String id) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.delete(Uri.parse('$apiUrl/delete-city/$id'));
    if (response.statusCode == 200) {
      fetchPlaces();
    } else {
      print("Failed to delete city");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),

                ElevatedButton(
                  onPressed: () {
                    showCityForm(context: context); // Show form to create a new city
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add City'),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image at the top of the card
                      place['images'] != null && place['images'].isNotEmpty
                          ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                        child: Image.network(
                          place['images'][0].startsWith('http')
                              ? place['images'][0]
                              : 'http://192.168.18.60:5009${place['images'][0]}',
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 120);
                          },
                        ),
                      )
                          : const Icon(Icons.location_city, size: 120),

                      // Name and location below the image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place['location'],
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Row for Edit and Delete buttons
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => deleteCity(place['_id']),
                                  color: Colors.red,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => showCityForm(
                                    context: context,
                                    id: place['_id'],
                                    existingName: place['name'],
                                    existingDescription: place['description'],
                                    existingLocation: place['location'],
                                    existingImages: List<String>.from(place['images']), // Pass existing images
                                  ),
                                  color: Colors.blue,
                                ),
                              ],
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
        ),
      ),
    );
  }
}
