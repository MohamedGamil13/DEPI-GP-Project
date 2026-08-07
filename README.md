# SkillBridge (ServiMarket)

A full-stack cross-platform **service marketplace** built with **Flutter** and **Firebase**, developed as a **DEPI (Digital Egypt Pioneers Initiative) Final Project**. SkillBridge connects service providers with buyers — enabling local discovery, in-app messaging, and secure transactions — all in one seamless mobile experience.

---

## ✨ Features

### 🔐 Authentication

- Email/password **sign in & sign up** via Firebase Auth
- **Google Sign-In** integration
- **Forgot password** flow with email reset
- **Persistent session** management with automatic route guarding (GoRouter redirects)
- Automatic user profile creation in Firestore on registration (including GPS-detected location)

### 🏠 Home Feed & Discovery

- **Real-time feed** of service ads loaded from Firestore
- **Keyword search** across post titles, descriptions, and categories
- **21 categories** with icons (Programming, Vehicles, Jobs, Games, Interns, Services, Events, Electronics, Real Estate, Fashion, Sports, Health, Education, Travel, Food, Books, Music, Furniture, Photography, Student Support)
- **Location-aware sorting** — posts are sorted by distance from the user's GPS position
- **Pull-to-refresh** with loading/error/empty states
- **Favorites / Wishlist** — save and unsave posts with real-time heart icon state updates, with failure rollback

### 📝 Post an Ad

- Create service ads with **title, description, price, category, city**
- Upload **1–3 photos** via the image picker (stored on **Cloudinary**)
- Tag posts with **relevant skills** (20 skills: Mobile, Web, Cyber Security, Game Development, DevOps, AI, Data Science, UI/UX Design, Blockchain, Cloud Computing, Networking, SEO/Marketing, Content Writing, Digital Marketing, Graphic Design, Video Editing, Project Management, Accounting, Languages, Teaching)
- **GPS-based location detection** using geolocator & reverse geocoding
- **23 Egyptian governorates** supported

### 📄 Ad Details

- Full post view with **hero image header**
- **Seller info card** with rating, reviews count, and "View Profile" shortcut
- **Call** contact button (via `url_launcher` `tel:` scheme)
- **Message Poster** — instantly creates/opens an in-app conversation
- **Ratings & Reviews** — average rating, total reviews, add-review sheet, and "See All" reviews screen
- **Badge** support for promoted/premium ads
- Favorite toggle with share action

### 💬 Messaging / Chat

- **In-app messaging** with **real-time chat** via Firestore streams
- Conversation inbox with **search** and **filters** (All / New Leads / Active)
- Conversation statuses: **New Lead, Active, Waiting, Closed**
- **Unread count badges**, online status indicators, and read receipts
- Message pagination (load older messages) and timestamp formatting
- **Deep links** (`skillbridge://chat?conversationId=...`) open conversations directly

### 👤 Profile

- Rich user profile with **avatar, name, bio, location, rating, and reviews**
- **Skills profile** — add/remove skills with a searchable picker
- Tabbed view of **user posts**
- View **other users' profiles** from any ad
- **Language switcher** (English / العربية) persisted locally

### 🔔 Notifications

- **Push notifications** via Firebase Cloud Messaging (FCM)
- **Local notifications** via `flutter_local_notifications`
- Foreground, background, and terminated-state message handling
- FCM **token sync** with Firestore (add/remove on sign in/out)
- **App Links** deep linking integration

### 🌍 Localization

- **English & Arabic (RTL)** support via `flutter_localizations`
- Generated localization with `flutter gen-l10n`
- Responsive UI with **flutter_screenutil** (design size 360×690)

---

## 🛠 Tech Stack

| Layer                    | Technology                                |
| ------------------------ | ----------------------------------------- |
| **Framework**            | Flutter (Dart SDK `^3.10.7`)              |
| **Backend**              | Firebase (Auth, Firestore, Messaging)     |
| **Image Storage**        | Cloudinary                                |
| **State Management**     | BLoC (`flutter_bloc`)                     |
| **Architecture**         | Clean Architecture + MVVM (feature-first) |
| **Dependency Injection** | GetIt                                     |
| **Routing**              | GoRouter                                  |
| **Local Storage**        | Hive CE                                   |
| **Networking**           | Dio                                       |
| **Location**             | Geolocator + Geocoding                    |
| **Animations**           | Lottie                                    |
| **Icons**                | Font Awesome                              |

---

## 📁 Project Structure

```
lib/
├── core/                     # Shared utilities, services, theme, routing
│   ├── errors/               # Custom exception classes (auth, storage, database, call)
│   ├── locator/              # GetIt service locator
│   ├── routing/              # GoRouter config & navigation
│   ├── services/             # Auth, chat, cloudinary, firestore, location, notifications, call
│   ├── theme/                # App colors & styles
│   ├── utils/                # Constants, helpers, validators, observers
│   └── widgets/              # Reusable UI components
├── features/
│   ├── auth/                 # Sign in, sign up, forgot password
│   ├── home/                 # Home feed, search, categories, favorites
│   ├── location/             # Location data model
│   ├── messages/             # Inbox, chat detail, conversations
│   ├── posts/                # Post ad, ad details, reviews, call
│   ├── profile/              # User profile & skills
│   └── splash/               # Splash screen
├── generated/                # Generated localization files
├── l10n/                     # Localization strings (en/ar)
├── firebase_options.dart     # Firebase config
└── main.dart                 # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.7`
- Firebase project with **Auth**, **Firestore**, and **Messaging** enabled
- Cloudinary account (for image uploads)

### Setup

```bash
# Clone the repository
git clone https://github.com/MohamedGamil13/DEPI-GP-Project.git
cd DEPI-GP-Project

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Add your Firebase config
# Download google-services.json → android/app/
# Download GoogleService-Info.plist → ios/Runner/

# Run the app
flutter run
```

---

## 🧩 Key Models

### Ad Categories (21)

Programming, Vehicles, Jobs, Games, Interns, Services, Events, Electronics, Real Estate, Fashion, Sports, Health, Education, Travel, Food, Books, Music, Furniture, Photography, Student Support

### Relevant Skills (20)

Mobile, Web, Cyber Security, Game Development, DevOps, AI, Data Science, UI/UX Design, Blockchain, Cloud Computing, Networking, SEO/Marketing, Content Writing, Digital Marketing, Graphic Design, Video Editing, Project Management, Accounting, Languages, Teaching

### Supported Cities (23)

All Egyptian governorates — Cairo, Giza, Alexandria, Port Said, Suez, Damietta, Dakahlia, Sharkia, Gharbia, Monufia, Beheira, Fayoum, Beni Suef, Minya, Assiut, Sohag, Qena, Luxor, Matrouh, Red Sea, North Sinai, South Sinai, Ismailia

---

## 📄 License

This project is developed as a **DEPI (Digital Egypt Pioneers Initiative) Final Project** for educational purposes.

---

## 👥 Contributors

- **Mohamed Gamil** — [GitHub](https://github.com/MohamedGamil13)
