import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // Move these outside of the build method so they persist across rebuilds
  String selectedType = 'Family'; // Default type selection
  DateTime? fromDate; // Store selected From date
  DateTime? toDate; // Store selected To date

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()), // Use the correct initial date
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFrom) {
          fromDate = selectedDate;
        } else {
          toDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Where to (TextField)
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Where to",
                  style: TextStyle(
                    color: AppColors.lavender,
                    fontSize: 12,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter keywords",
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          // When (Date)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "   From",
                style: TextStyle(
                  color: AppColors.lavender,
                  fontSize: 12,
                ),
              ),
              TextButton(
                onPressed: () {
                  _selectDate(context, true); // Select From Date
                },
                child: Text(
                  fromDate != null
                      ? DateFormat('MM/dd/yyyy').format(fromDate!)
                      : 'Select From Date   ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "   To",
                style: TextStyle(
                  color: AppColors.lavender,
                  fontSize: 12,
                ),
              ),
              TextButton(
                onPressed: () {
                  _selectDate(context, false); // Select To Date
                },
                child: Text(
                  toDate != null
                      ? DateFormat('MM/dd/yyyy').format(toDate!)
                      : 'Select To Date   ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          // Type (Dropdown)
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Type",
                style: TextStyle(
                  color: AppColors.lavender,
                  fontSize: 12,
                ),
              ),
              DropdownButton<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(
                    value: 'Family',
                    child: Text('Family'),
                  ),
                  DropdownMenuItem(
                    value: 'Solo',
                    child: Text('Solo'),
                  ),
                  DropdownMenuItem(
                    value: 'Couple',
                    child: Text('Couple'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
            ],
          ),
          // Find Now Button
          const SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              backgroundColor: AppColors.lavender,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Add search logic here
            },
            child: const Text(
              "FIND NOW",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
