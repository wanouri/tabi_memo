# tabi\_memo

**tabi\_memo** is a simple and elegant travel journaling app built with Flutter. It helps users to document their trips, store photos, expenses, and memories easily. Perfect for business travelers, weekend wanderers, and everyone in between.

---

## 📱 Features

* ✈️ Record trips with title, date, notes
* 🖼️ Attach photos to each record
* 💰 Input and track expenses
* 🔍 Search your past journeys
* 📆 Calendar feature for easy lookup *(coming soon)*
* 📤 Share to SNS (Instagram, X/Twitter) *(planned)*

---

## 🚀 Getting Started

### Prerequisites

* Flutter 3.29.3 or later
* Dart 3.7.2 or later
* Android Studio / VS Code

### Build & Run

```bash
flutter pub get
flutter run
```

### For release build:

```bash
flutter build appbundle # or flutter build apk
```

> 📌 Ensure that your `key.properties` and `keystore.jks` are correctly set up for release builds. These should **not** be committed to source control.

---

## 📁 Project Structure

```
tabi_memo/
├── android/
│   ├── app/
│   │   └── keystore.jks (not included)
│   └── key.properties (not included)
├── assets/
│   └── store/
│       ├── icon/
│       ├── feature/
│       └── screenshots/
├── lib/
│   └── main.dart
├── README.md
└── ...
```

---

## 🛡️ Signing (Release Build)

Place your signing key and configuration in:

* `android/app/keystore.jks`
* `android/key.properties`

Example `key.properties`:

```
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=your-key-alias
storeFile=keystore.jks
```

Make sure these files are listed in `.gitignore`.

---

## 🧭 Roadmap

* [x] Trip memo CRUD
* [x] Expense tracking
* [x] Image attachment
* [x] Release to Google Play (alpha)
* [ ] Calendar-based lookup
* [ ] SNS sharing
* [ ] Categorization by trip type

---

## 🧑‍💻 Author

**Yoshiyuki Matsumoto**
[GitHub](https://github.com/wanouri)

---

## 📜 License

MIT License
