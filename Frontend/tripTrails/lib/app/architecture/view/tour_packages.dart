import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // Fetch all tour packages from API
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

  // Function to show create/edit package form
  void showPackageForm(BuildContext context, {dynamic package}) {
    final titleController = TextEditingController(text: package?['title'] ?? '');
    final descriptionController =
    TextEditingController(text: package?['description'] ?? '');
    final priceController =
    TextEditingController(text: package?['price']?.toString() ?? '');
    final durationController =
    TextEditingController(text: package?['duration'] ?? '');
    final locationController =
    TextEditingController(text: package?['location'] ?? '');
    String packageType = package?['packageType'] ?? 'Family';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(package != null ? 'Edit Package' : 'Create Package'),
          content: Form(
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
              ],
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
                    );
                  } else {
                    createPackage(
                      titleController.text,
                      descriptionController.text,
                      double.parse(priceController.text),
                      durationController.text,
                      locationController.text,
                      packageType,
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

  // Function to create a new tour package
  Future<void> createPackage(String title, String description, double price,
      String duration, String location, String packageType) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add-package'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'price': price,
        'duration': duration,
        'location': location,
        'packageType': packageType,
      }),
    );

    if (response.statusCode == 201) {
      fetchPackages(); // Refresh list after creation
    } else {
      print('Failed to create package');
    }
  }

  // Function to update an existing tour package
  Future<void> updatePackage(String id, String title, String description,
      double price, String duration, String location, String packageType) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update-package/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'price': price,
        'duration': duration,
        'location': location,
        'packageType': packageType,
      }),
    );

    if (response.statusCode == 200) {
      fetchPackages(); // Refresh list after update
    } else {
      print('Failed to update package');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Row with Packages heading and Add Package button
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
          // List of packages
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(package['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${package['description']}'),
                          Text('Price: Rs ${package['price']}'),
                          Text('Duration: ${package['duration']}'),
                          Text('Location: ${package['location']}'),
                          Text('Package Type: ${package['packageType']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => showPackageForm(context, package: package),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deletePackage(package['_id']),
                          ),
                        ],
                      ),
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
