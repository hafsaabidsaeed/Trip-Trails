// add_package_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddPackageController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  String packageType = 'Family';
  final formKey = GlobalKey<FormState>();

  final String apiUrl = 'http://192.168.18.60:5009/api/tour-packages/add-package';

  void createPackage() async {
    if (formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': titleController.text,
          'description': descriptionController.text,
          'price': double.parse(priceController.text),
          'duration': durationController.text,
          'location': locationController.text,
          'packageType': packageType,
        }),
      );

      if (response.statusCode == 201) {
        print('Package created successfully');
      } else {
        print('Failed to create package');
      }
    }
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    durationController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }
}
