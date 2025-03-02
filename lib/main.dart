import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const NextDNSToggleApp());
}

class NextDNSToggleApp extends StatefulWidget {
  const NextDNSToggleApp({super.key});

  @override
  State<NextDNSToggleApp> createState() => _NextDNSToggleAppState();
}

class _NextDNSToggleAppState extends State<NextDNSToggleApp> {
  bool isBlocked = false;
  String apiKey = "";
  String profileId = "";

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      apiKey = prefs.getString("apiKey") ?? "";
      profileId = prefs.getString("profileId") ?? "";
    });
    if (apiKey.isNotEmpty && profileId.isNotEmpty) {
      fetchBlockState();
    }
  }

  Future<void> saveSettings(String newApiKey, String newProfileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("apiKey", newApiKey);
    await prefs.setString("profileId", newProfileId);
    setState(() {
      apiKey = newApiKey;
      profileId = newProfileId;
    });
    fetchBlockState();
  }

  Future<void> fetchBlockState() async {
    if (apiKey.isEmpty || profileId.isEmpty) return;
    final url = "https://api.nextdns.io/profiles/$profileId";
    final response = await http.get(Uri.parse(url), headers: {
      "X-Api-Key": apiKey,
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      bool found = jsonResponse["privacy"]["blocklists"]
          ?.any((blocklist) => blocklist["id"] == "no-g") ?? false;

      setState(() {
        isBlocked = found;
      });
    }
  }

  Future<void> toggleBlocking() async {
    if (apiKey.isEmpty || profileId.isEmpty) return;
    final url = "https://api.nextdns.io/profiles/$profileId";
    final blocklists = isBlocked
        ? '[{"id": "nextdns-recommended"}, {"id": "easylist"}]'
        : '[{"id": "nextdns-recommended"}, {"id": "easylist"}, {"id": "no-g"}]';

    final response = await http.patch(Uri.parse(url),
        headers: {
          "X-Api-Key": apiKey,
          "Content-Type": "application/json"
        },
        body: '{"privacy": {"blocklists": $blocklists}}');

    if (response.statusCode == 200) {
      setState(() {
        isBlocked = !isBlocked;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("isBlocked", isBlocked);
    }
  }

  void openSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          apiKey: apiKey,
          profileId: profileId,
          onSave: saveSettings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("NextDNS Google Blocker"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: openSettingsScreen,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                apiKey.isEmpty || profileId.isEmpty
                    ? "Please set API Key & Profile ID"
                    : isBlocked
                        ? "Google is BLOCKED"
                        : "Google is ALLOWED",
                style: const TextStyle(fontSize: 20),
              ),
              if (apiKey.isNotEmpty && profileId.isNotEmpty)
                Switch(
                  value: isBlocked,
                  onChanged: (value) => toggleBlocking(),
                ),
              if (apiKey.isEmpty || profileId.isEmpty)
                ElevatedButton(
                  onPressed: openSettingsScreen,
                  child: const Text("Set API Key & Profile ID"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}