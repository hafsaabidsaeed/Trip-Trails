// add_package_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/admin controllers/add package controller.dart';

class AddPackageScreen extends StatefulWidget {
  @override
  _AddPackageScreenState createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final AddPackageController controller = AddPackageController();

  @override
  void dispose() {
    controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                SizedBox(height: 16),
                Text(
                  'Travel Package Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Title Field
                TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    labelText: 'Package Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a package name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Price Field
                TextFormField(
                  controller: controller.priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    suffixText: 'PKR',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Duration Field
                TextFormField(
                  controller: controller.durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a duration';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Start Date and End Date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.startDateController,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            controller.startDateController.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a start date';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: controller.endDateController,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            controller.endDateController.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an end date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Location Field
                TextFormField(
                  controller: controller.locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Package Type Dropdown
                DropdownButtonFormField<String>(
                  value: controller.packageType,
                  items: ['Family', 'Couple', 'Solo'].map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.packageType = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Package Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32),

                // Create Package Button
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.createPackage();
                      Navigator.of(context).pop(); // Close the screen after adding package
                    },
                    child: const Text(
                      'Create Package',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
