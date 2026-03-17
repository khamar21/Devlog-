# 🚀 DevLog Pro (Flutter)

DevLog Pro is a modern **developer productivity tracking app** built using Flutter. It helps developers manage projects, track time, organize tasks, and analyze weekly progress efficiently.

---

## 📱 Features

* 📊 Dashboard overview with insights
* ⏱️ Time tracking & time entry flow
* 📁 Project management with detailed views
* ✅ Task management system
* 👤 User profile section
* 📈 Weekly progress reports

---

## 🛠️ Tech Stack

* **Frontend:** Flutter (Material 3), Dart
* **State Management:** Provider
* **Networking:** HTTP
* **Charts:** fl_chart
* **UI Enhancements:** google_fonts, flutter_svg
* **Storage:** shared_preferences
* **Backend:** Appwrite SDK + REST API

---

## 📂 Project Structure

```
lib/
├── main.dart
├── config/
│   └── environment.dart
├── core/
│   └── theme.dart
├── data/
│   ├── api_service.dart
│   └── appwrite_client.dart
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── profile/
│   ├── projects/
│   ├── tasks/
│   └── tracking/
└── widgets/
```

---

## ⚙️ API Configuration

* **Production API:**
  https://devlogpro-api.onrender.com/api

* **Local Development (Android Emulator):**
  http://10.0.2.2:3000/api

👉 Configure in:
`lib/data/api_service.dart`

---

## 🚀 Getting Started

### 1️⃣ Prerequisites

* Flutter SDK installed
* Emulator / Physical device

```bash
flutter doctor
```

---

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

---

### 3️⃣ Run the App

```bash
flutter run
```

Run on specific platform:

```bash
flutter run -d chrome
flutter run -d android
flutter run -d windows
```

---

### 4️⃣ Run Tests

```bash
flutter test
```

---

## 📦 Build Commands

```bash
flutter build apk
flutter build appbundle
flutter build web
flutter build windows
```

---

## 🔐 Important Notes

* Do not expose API keys or secrets
* Move sensitive configs to secure storage before production
* Supports multiple platforms (Android, iOS, Web, Desktop)

---

## 🌟 Future Improvements

* 🔔 Notifications & reminders
* ☁️ Cloud sync enhancements
* 🤖 AI-based productivity insights
* 📊 Advanced analytics dashboard

---

## 👩‍💻 Author

**Nafeesathul Kamariyya**
Flutter Developer | Full Stack Enthusiast

---

## ⭐ Support

If you like this project, consider giving it a ⭐ on GitHub!
