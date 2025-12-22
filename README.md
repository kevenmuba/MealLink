# MealLink - Flutter Prepaid Meal Management App

## Project Overview
MealLink is a mobile Flutter app for managing prepaid meals and tracking daily food usage.
This repository contains the Flutter project with clean, professional folder structure and industry-standard Git workflow.

---

## Folder Structure (Feature-First Clean Architecture)

lib/
├── core/                 # Global constants, theme, utilities
│   ├── constants/        # Colors, strings, API endpoints
│   ├── theme/            # Light/Dark theme, text styles
│   └── utils/            # Helper functions (formatters, validators)
│
├── features/             # Each feature is self-contained
│   ├── home/             # Home feature
│   │   ├── screens/      # UI pages
│   │   │   └── home_screen.dart
│   │   ├── controllers/  # Business logic / state
│   │   ├── services/     # API / DB services
│   │   └── models/       # Data models
│   ├── auth/             # Authentication feature (future)
│   └── meal/             # Meal management feature (future)
│
├── shared/               # Reusable widgets or services
│   ├── widgets/          # Buttons, dialogs, cards
│   └── services/         # Shared API clients, storage
│
└── main.dart             # App entry point

Notes:
- Each feature contains its screens, controllers, services, and models
- Only truly global services or widgets go in shared/
- core/ holds constants, theme, and utils for the whole app
- This structure is professional, scalable, and team-friendly

---

## Setup Instructions

1. Clone the repository:

    git clone https://github.com/kevenmuba/MealLink.git
    cd meallink

2. Switch to a branch (never work directly on main except for initial push):

    git checkout -b <your-feature-branch>

3. Install Flutter dependencies:

    flutter pub get

4. Run the app:

    flutter run

- Make sure you have an emulator or device connected.
- The first screen shows task delegation instructions for the team.

---

## Git Workflow (Professional)

1. Always pull latest main before starting:

    git pull origin main

2. Create a branch for your work:

    git checkout -b feature/<your-feature-name>

3. Add & commit your changes:

    git add .
    git commit -m "Add <feature-description>"

4. Push your branch to GitHub:

    git push -u origin feature/<your-feature-name>

5. Never push directly to main after the initial setup
6. Create Pull Requests to merge changes into main after review

---

## Initial Push to Main (only once)

If this is the first push, follow:

    git branch -M main
    git add .
    git commit -m "Initial Flutter project setup with HomeScreen and folder structure"
    git push -u origin main

- If the remote contains a README or license, pull first:

    git pull origin main --allow-unrelated-histories
    git push -u origin main

---

## Notes for Team Members

- Folder structure is feature-first
- Screens belong inside features
- Controllers handle logic; Services handle API/data
- Always pull → branch → commit → push workflow
- Follow this README to avoid breaking the main branch

---

## Next Steps (For Future Development)

- Add Auth feature (login/signup)
- Add Meal management feature (daily meals, plans)
- Implement shared services (API client, storage)
- Write unit and widget tests per feature
