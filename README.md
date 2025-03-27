# TrackPak Mobile Apps (Customer & Driver)

This is the **TrackPak Mobile Apps Monorepo**! This setup contains both the **Customer App** and **Driver App**, with a shared Dart package used for common logic, models, and UI components.

---

## 📁 Project Structure

```bash
.
├── apps/
│   ├── customer_app/         # 📦 Flutter app for end-customers
│   └── driver_app/           # 🚚 Flutter app for drivers
│
└── shared/                   # 🔗 Shared Dart package (models, BLoCs, utils)
```

---

## ⚙️ Prerequisites

Before you begin, ensure you have the following installed:

- Flutter SDK (version 3.13.0+ recommended)
- Dart SDK
- Android Studio or Xcode (for Android/iOS builds)


## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone [Repo link](https://github.com/Csejrup/trackpak-app.git)
cd trackpak-app
```

### 2. Install dependencies

```bash
cd shared && flutter pub get
cd ../apps/customer_app && flutter pub get
cd ../driver_app && flutter pub get
```

### 3. Run the apps

#### Customer App:

```bash
cd apps/customer_app
flutter run
```

#### Driver App:

```bash
cd apps/driver_app
flutter run
```

---

## 🔗 Shared Package

Both apps depend on the `shared/` package. Any changes made here (e.g. models, BLoCs, or providers) will be reflected across both apps.

Make sure to re-run `flutter pub get` in each app after updating shared code.

