# Alzheimer SmartCare (Mobile App)

A cross-platform mobile app (Android & iOS) built with Flutter to support Alzheimer’s patients and caregivers through reminders and supportive tools.

> Graduation Project — Alzheimer SmartCare

---

## ✨ Key Features
- User authentication (Doctor / Patient / Caregiver)
- Medication reminders (create, update, upcoming reminders)
- Face image registration / storage support
- QR code generation for pairing
- Cognitive games & supportive UI flows

---

## 🛠 Tech Stack
- Flutter (Dart)
- REST API integration

---

## 🔗 Backend API
Production API:
- Base API: `https://alzheimersgp.runasp.net/api/`
- Swagger: `https://alzheimersgp.runasp.net/swagger/index.html`

---

## ⚙️ API Endpoints Configuration
This app uses multiple URLs depending on the feature:

### 1) Main API (Production)
Used for auth, reminders, and face images:
- `baseUrl = https://alzheimersgp.runasp.net/api/`

### 2) Local API (Development)
For local testing:
- `testUrl = http://localhost:5267/api/`

### 3) Models Service (External)
Used for AI/model predictions:
- `modelsUrl = https://<replit-url>/`

### 4) QR Code Generator (External)
Used for generating QR codes:
- `QrCode = https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=PAIRING_TOKEN`

> You can find these values in: `Endpoints` class inside the project.

---

## 📸 Screenshots
> Put screenshots under: `docs/screens/`

| Screen | Preview |
|-------|---------|
| Splash | ![](docs/screens/splash.png) |
| Sign Up | ![](docs/screens/signup.png) |
| Profile | ![](docs/screens/profile.png) |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / Xcode

### Run
```bash
git clone <REPO_URL>
cd Alzheimer-Smartcare
flutter pub get
flutter run
