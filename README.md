# NextDNS Google Blocker

## 📌 Overview
This is a **Flutter-based** mobile app for **iOS and Android** that allows users to quickly toggle Google blocking on their **NextDNS profile**. It provides:

✅ **A simple toggle switch** to block/unblock Google.
✅ **Secure API Key & Profile ID storage** using `SharedPreferences`.
✅ **A settings screen** where users can enter their own NextDNS credentials.
✅ **Direct API calls to NextDNS** to modify blocklists.

---

## 🚀 Features
- **Toggle Google Blocking** on/off with a single tap.
- **Stores API Key & Profile ID securely** for future use.
- **Fetches current blocklist state** from NextDNS API.
- **Works on both iOS & Android**.

---

## 📲 Installation
### **1️⃣ Install Flutter**
Ensure you have Flutter installed:
```sh
flutter --version
```
If not installed, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### **2️⃣ Clone the Repository**
```sh
git clone https://github.com/YOUR_USERNAME/nextdns_toggle.git
cd nextdns_toggle
```

### **3️⃣ Install Dependencies**
```sh
flutter pub get
```

### **4️⃣ Run the App**
For Android:
```sh
flutter run
```
For iOS:
```sh
flutter build ios
flutter run
```

---

## 🛠 Configuration
1. Open the **Settings screen** in the app.
2. Enter your **NextDNS API Key** and **Profile ID**.
3. Tap **Save**.
4. The app will now fetch and control your NextDNS settings.

---

## 🔧 How It Works
### **🔹 Fetching NextDNS Blocklist State**
The app sends a `GET` request to:
```
https://api.nextdns.io/profiles/{profileId}
```
It checks whether `"no-g"` exists in the returned `blocklists` array:
```json
{
  "privacy": {
    "blocklists": [
      { "id": "nextdns-recommended" },
      { "id": "easylist" },
      { "id": "no-g" }
    ]
  }
}
```
If `"no-g"` exists, Google blocking is **ON**.

### **🔹 Toggling Google Blocking**
The app sends a `PATCH` request to update `blocklists`:

- **Enable blocking:**
```json
{"privacy": {"blocklists": [{"id": "nextdns-recommended"}, {"id": "easylist"}, {"id": "no-g"}]}}
```
- **Disable blocking:**
```json
{"privacy": {"blocklists": [{"id": "nextdns-recommended"}, {"id": "easylist"}]}}
```

---

## 📌 Roadmap & Future Enhancements
🔹 **Add a Home Screen Widget** for instant toggling without opening the app.
🔹 **Implement notifications** to alert users when Google blocking is toggled.
🔹 **Dark mode UI** for better user experience.

---

## 💡 Contributions
Contributions are welcome! Feel free to submit a pull request or open an issue.

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙌 Credits
Developed by Will Wade with Flutter and NextDNS API.

---

🚀 **Enjoy fast and secure control over Google blocking on NextDNS!**

