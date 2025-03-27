# 🚀 TrackPak Mobile Apps (Customer & Driver)

Welcome to the **TrackPak Mobile Apps Monorepo**! This setup contains both the **Customer App** and **Driver App**, with a shared Dart package used for common logic, models, and UI components.

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
- `melos` (for managing monorepo — optional but recommended)

Install `melos` globally:

```bash
dart pub global activate melos
```

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone <your-repo-url>
cd trackpak-monorepo
```

### 2. Bootstrap all packages (if using `melos`)

```bash
melos bootstrap
```

### 3. Install dependencies manually (if not using melos)

```bash
cd shared && flutter pub get
cd ../apps/customer_app && flutter pub get
cd ../driver_app && flutter pub get
```

### 4. Run the apps

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

---

## 🧪 Testing

You can write unit and widget tests in each project by running:

```bash
flutter test
```

---

## 👥 Auth0 Integration

Both apps rely on Auth0 for authentication. Credentials and domain config should be placed in a secure `.env` or injected via secrets/config.

---

## 📦 Additional Tips

- You can alias each app in VS Code/Android Studio for quick switching.
- Use `melos run` scripts to automate repetitive dev tasks across apps.

---

## 👨‍💻 Maintainers

- @capacit (backend & architecture)
- @yourname (mobile lead)

---

Happy Building! ⚡
