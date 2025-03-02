import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String apiKey;
  final String profileId;
  final Function(String, String) onSave;

  const SettingsScreen({
    super.key,
    required this.apiKey,
    required this.profileId,
    required this.onSave,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController apiKeyController;
  late TextEditingController profileIdController;

  @override
  void initState() {
    super.initState();
    apiKeyController = TextEditingController(text: widget.apiKey);
    profileIdController = TextEditingController(text: widget.profileId);
  }

  @override
  void dispose() {
    apiKeyController.dispose();
    profileIdController.dispose();
    super.dispose();
  }

  void saveSettings() {
    widget.onSave(apiKeyController.text, profileIdController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(labelText: "NextDNS API Key"),
              obscureText: true,
            ),
            TextField(
              controller: profileIdController,
              decoration: const InputDecoration(labelText: "NextDNS Profile ID"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveSettings,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}