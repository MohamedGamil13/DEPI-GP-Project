# ServiMarket 

A full-stack cross-platform service marketplace built with Flutter and Firebase, developed as a DEPI Final Project. ServiMarket connects service providers with buyers through smart matching, collaborative booking, and local discovery.

---

## Features

###  Core
- **Authentication** — Email/password login & registration via Firebase Auth, with persistent session and role-based profiles (Student / Provider / Regular)
- **Service Posting** — Create, edit, and delete service ads with title, description, category, price, city tag, and up to 3 images
- **Home Feed + Search + Filters** — Real-time stream of posts with keyword search, category/city filters, and paginated loading (20 posts/batch)
- **Service Detail Screen** — Full post view with swipeable image gallery, seller info, Call & WhatsApp contact buttons, and a comments section
- **Favorites / Wishlist** — Save and unsave posts with real-time heart icon state updates

###  Recommended
- **CV / Skill Matcher** — Tag-based scoring system that matches users to relevant tech/student posts based on their skill profile. Posts are scored and labeled as *Great Match*, *Stretch*, or *Overqualified*
- **Group Campaign** — Collaborative booking feature where multiple users join a service at a lower per-person price, powered by atomic Firestore transactions with a live countdown timer
- **Student Services Section** — Dedicated tab for student-to-student academic help, filterable by subject, area, and free/paid status
- **Local Services Filter** — Toggle to show only posts matching the user's saved city, with a planned GPS radius upgrade

###  Nice to Have
- Dark Mode with system-aware theming
- Google Sign-In
- Push Notifications via FCM
- Ratings & Reviews
- GPS-Based Location Filter
- In-App Messaging / Chat
- Premium / Promoted Ads

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Backend | Firebase (Auth, Firestore, Storage) |
| State Management | BLoC |
| Architecture | Clean Architecture + MVVM |
| Local Storage | — |

---

## Project Structure

```
lib/
├── core/             # Shared utilities, constants, theme
├── features/
│   ├── auth/         # Login, register, profile
│   ├── feed/         # Home feed, search, filters
│   ├── post/         # Post creation, detail, editing
│   ├── matcher/      # CV/Skill Matcher logic
│   ├── campaign/     # Group Campaign feature
│   ├── student/      # Student Services section
│   └── favorites/    # Wishlist screen
└── main.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Firebase project with Auth, Firestore, and Storage enabled

### Setup

```bash
# Clone the repository
git clone https://github.com/your-username/servimarket.git
cd servimarket

# Install dependencies
flutter pub get

# Add your Firebase config
# Download google-services.json → android/app/
# Download GoogleService-Info.plist → ios/Runner/

# Run the app
flutter run
```

---

## Skill Matcher Logic

Each Tech/Student post is tagged with required skills and a skill level (Beginner / Mid / Senior).

| Condition | Score |
|---|---|
| User's skill matches post requirement | +2 |
| User is one level below requirement | +1 |
| No match | 0 |

Posts with score > 0 appear in the Matched Feed, sorted by best match first.

---

## Group Campaign Flow

1. Any service post can have a Campaign launched on it
2. Creator sets: target headcount, price per person, deadline
3. Users join via an atomic Firestore transaction (safe for concurrent joins)
4. Live counter updates in real time: `3 / 5 joined`
5. Campaign auto-closes when target is reached and notifies all participants

