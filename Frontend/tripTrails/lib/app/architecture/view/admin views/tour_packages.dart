import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

import 'package:triptrails/app/theme/app_colors.dart';

class TourPackagesPage extends StatefulWidget {
  @override
  _TourPackagesPageState createState() => _TourPackagesPageState();
}

class _TourPackagesPageState extends State<TourPackagesPage> {
  List<dynamic> packages = [];
  bool isLoading = true;
  final String apiUrl = 'http://192.168.18.60:5009/api/tour-packages'; // API base URL

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('$apiUrl/get-packages'));
    if (response.statusCode == 200) {
      setState(() {
        packages = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to delete a package
  Future<void> deletePackage(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete-package/$id'));
    if (response.statusCode == 200) {
      fetchPackages();
    } else {
      print("Failed to delete package");
    }
  }

  void showPackageForm(BuildContext context, {dynamic package}) {
    final titleController = TextEditingController(text: package?['title'] ?? '');
    final descriptionController = TextEditingController(text: package?['description'] ?? '');
    final priceController = TextEditingController(text: package?['price']?.toString() ?? '');
    final durationController = TextEditingController(text: package?['duration'] ?? '');
    final locationController = TextEditingController(text: package?['location'] ?? '');
    final startDateController = TextEditingController(text: package?['startDate'] ?? '');
    final endDateController = TextEditingController(text: package?['endDate'] ?? '');
    String packageType = package?['packageType'] ?? 'Family';

    List<html.File> newImages = [];
    List<String> existingImages = package?['images'] != null ? List<String>.from(package['images']) : [];

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(package != null ? 'Edit Package' : 'Create Package'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
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
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: durationController,
                    decoration: const InputDecoration(labelText: 'Duration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a duration';
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
                  // Start Date Field
                  TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  // End Date Field
                  TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  // Package Type Dropdown
                  DropdownButtonFormField<String>(
                    value: packageType,
                    items: ['Family', 'Couple', 'Solo'].map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        packageType = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Package Type'),
                  ),
                  // Display Existing Images
                  existingImages.isNotEmpty
                      ? Wrap(
                    children: existingImages.map((imageUrl) {
                      return Image.network('http://192.168.18.60:5009' + imageUrl, width: 100, height: 100);
                    }).toList(),
                  )
                      : Text('No images selected'),
                  // Image Upload Field
                  ElevatedButton(
                    onPressed: () {
                      html.FileUploadInputElement uploadInput = html.FileUploadInputElement()..accept = 'image/*';
                      uploadInput.click();
                      uploadInput.onChange.listen((e) {
                        final files = uploadInput.files;
                        if (files!.isNotEmpty) {
                          setState(() {
                            newImages.addAll(files);
                          });
                        }
                      });
                    },
                    child: Text('Select New Images'),
                  ),
                  newImages.isNotEmpty
                      ? Wrap(
                    children: newImages.map((file) {
                      return Image.network(html.Url.createObjectUrl(file), width: 100, height: 100);
                    }).toList(),
                  )
                      : Text('No new images selected'),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (package != null) {
                    updatePackage(
                      package['_id'],
                      titleController.text,
                      descriptionController.text,
                      double.parse(priceController.text),
                      durationController.text,
                      locationController.text,
                      packageType,
                      startDateController.text,
                      endDateController.text,
                      existingImages, // Pass existing images
                      newImages, // Pass new images
                    );
                  } else {
                    createPackage(
                      titleController.text,
                      descriptionController.text,
                      double.parse(priceController.text),
                      durationController.text,
                      locationController.text,
                      packageType,
                      startDateController.text,
                      endDateController.text,
                      newImages, // Pass new images for creation
                    );
                  }
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text(package != null ? 'Update' : 'Create'),
            ),
          ],
        );
      },
    );
  }


// Function to update an existing tour package
  Future<void> updatePackage(
      String id,
      String title,
      String description,
      double price,
      String duration,
      String location,
      String packageType,
      String startDate,
      String endDate,
      List<String> existingImages,
      List<html.File> newImages,
      ) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$apiUrl/update-package/$id'),
    );

    // Adding form fields
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['duration'] = duration;
    request.fields['location'] = location;
    request.fields['packageType'] = packageType;
    request.fields['startDate'] = startDate;
    request.fields['endDate'] = endDate;

    // Add existing images to the request
    for (var imageUrl in existingImages) {
      request.fields['existingImages[]'] = imageUrl;
    }

    // Add new images if they are uploaded
    for (var image in newImages) {
      var reader = html.FileReader();
      reader.readAsArrayBuffer(image);

      await reader.onLoadEnd.first;

      request.files.add(http.MultipartFile.fromBytes(
        'images',
        reader.result as List<int>,
        filename: image.name,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Package updated successfully');
      fetchPackages(); // Refresh the package list
    } else {
      print('Failed to update package');
      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  }


  Future<void> createPackage(
      String title,
      String description,
      double price,
      String duration,
      String location,
      String packageType,
      String startDate,
      String endDate,
      List<html.File> images,
      ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/add-package'),
    );

    // Adding form fields
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['duration'] = duration;
    request.fields['location'] = location;
    request.fields['packageType'] = packageType;
    request.fields['startDate'] = startDate;
    request.fields['endDate'] = endDate;

    // Add each image file to the request
    for (var image in images) {
      var reader = html.FileReader();
      reader.readAsArrayBuffer(image); // Read the file as an array buffer

      await reader.onLoadEnd.first; // Wait for the image to fully load

      // Add the image as multipart file
      request.files.add(http.MultipartFile.fromBytes(
        'images', // Field name for images
        reader.result as List<int>, // File data
        filename: image.name, // File name
        contentType: MediaType('image', 'jpeg'), // Set content type based on the image type
      ));
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 201) {
      print('Package created successfully');
      fetchPackages(); // Refresh the package list
    } else {
      print('Failed to create package');
      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Packages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () => showPackageForm(context),
                child: const Text('Add Package'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // No rounded corners
                    ),
                    elevation: 2, // Optionally, adjust elevation for a flat look
                    child: Row(
                      children: [
                        // Left half (scrollable images)
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 270, // Set the height to match the ListTile content
                            child: package['images'] != null &&
                                package['images'].isNotEmpty
                                ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: package['images'].length,
                              itemBuilder: (context, imgIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    'http://192.168.18.60:5009' +
                                        package['images'][imgIndex],
                                    width: 290, // Ensure consistent width for each image
                                    height: 150, // Match height of the ListTile
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image,
                                          size: 100);
                                    },
                                  ),
                                );
                              },
                            )
                                : const Icon(Icons.image_not_supported, size: 100),
                          ),
                        ),

                        // Right half (data and buttons)
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  package['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('Description: ${package['description']}'),
                                Text('Price: Rs ${package['price']}'),
                                Text('Duration: ${package['duration']}'),
                                Text('Location: ${package['location']}'),
                                Text('Package Type: ${package['packageType']}'),
                                Text('Start Date: ${package['startDate']}'),
                                Text('End Date: ${package['endDate']}'),
                                const SizedBox(height: 8),

                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: AppColors.lavender,),
                                      onPressed: () =>
                                          showPackageForm(context, package: package),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: AppColors.lavender,),
                                      onPressed: () =>
                                          deletePackage(package['_id']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
