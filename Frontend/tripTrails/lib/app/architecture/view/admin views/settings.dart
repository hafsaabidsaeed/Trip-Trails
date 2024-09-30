import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  @override
  _AdminSettingsScreenState createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool notificationsEnabled = true;
  bool isDarkMode = false;
  TextEditingController adminEmailController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  TextEditingController backupEmailController = TextEditingController();

  @override
  void dispose() {
    adminEmailController.dispose();
    adminPasswordController.dispose();
    backupEmailController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    // Save settings to backend
    // Logic to save the settings goes here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Settings saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "General Settings",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 10),

            // Enable Notifications
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),

            // Dark Mode Toggle
            SwitchListTile(
              title: Text('Enable Dark Mode'),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),

            SizedBox(height: 30),

            // Header
            Text(
              "Admin Account",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 10),

            // Admin Email
            TextFormField(
              controller: adminEmailController,
              decoration: InputDecoration(
                labelText: 'Admin Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Admin Password
            TextFormField(
              controller: adminPasswordController,
              decoration: InputDecoration(
                labelText: 'Change Admin Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),

            // Header
            Text(
              "Backup Settings",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 10),

            // Backup Email
            TextFormField(
              controller: backupEmailController,
              decoration: InputDecoration(
                labelText: 'Backup Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Save Settings', style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
