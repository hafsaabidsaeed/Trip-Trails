import 'package:flutter/material.dart';

class PackageSelectionScreen extends StatefulWidget {
  @override
  _PackageSelectionScreenState createState() => _PackageSelectionScreenState();
}

class _PackageSelectionScreenState extends State<PackageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3, // Number of tabs (Basic, Standard, Premium)
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            children: [
              TabBar(
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black45,
                indicatorColor: Colors.black87,
                tabs: [
                  Tab(text: 'Basic'),
                  Tab(text: 'Standard'),
                  Tab(text: 'Premium'),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPackageCard(
              screenWidth,
              packageTitle: 'BASIC',
              price: 'PKR 4,376',
              description:
              'Promote 1 YouTube video promotion to expected 1000-1100 people worldwide.',
              deliveryTime: '3-day delivery',
            ),
            _buildPackageCard(
              screenWidth,
              packageTitle: 'STANDARD',
              price: 'PKR 7,000',
              description:
              'Promote 2 YouTube videos to an audience of 2500 people worldwide.',
              deliveryTime: '2-day delivery',
            ),
            _buildPackageCard(
              screenWidth,
              packageTitle: 'PREMIUM',
              price: 'PKR 10,000',
              description:
              'Promote 5 YouTube videos to an audience of 5000 people worldwide.',
              deliveryTime: '1-day delivery',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(double screenWidth,
      {required String packageTitle,
        required String price,
        required String description,
        required String deliveryTime}) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.all(16),
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
          // Package title and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                packageTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                price,
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
            description,
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
                deliveryTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 20), // Spacing before button
          // Continue Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 14), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Action for continue
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Compare Packages Button
          Center(
            child: TextButton(
              onPressed: () {
                // Compare packages action here
              },
              child: Text(
                'Compare packages',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
