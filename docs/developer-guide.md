# MealLink – Developer Guide (MVP 1)

This document is a **technical developer guide** for implementing **MealLink MVP 1**.
It is intended for all contributors working on the Flutter app and Firebase backend.

---

## 1. Goal of MVP 1

The goal of MVP 1 is to deliver a **working customer-focused prepaid meal system** within **36–48 hours**.

Key priorities:

* Speed over perfection
* Simplicity over over-engineering
* Clear responsibilities

MVP 1 focuses on **customers**, not SaaS features or complex admin systems.

---

## 2. Tech Stack

### Frontend

* **Flutter**

  * Android-first for MVP
  * Clean, feature-first architecture

### Backend & Database

* **Firebase**

  * Firebase Authentication
  * Cloud Firestore
  * Firebase Cloud Functions (optional, minimal)

---

## 3. Roles (Technical Perspective)

### Customer

* Registers account
* Logs in after admin approval
* Views balance & meal usage
* Makes payments
* Receives notifications

### Admin (Limited)

* Approves customer registration
* Approves daily meal consumption

⚠️ Admin UI is minimal and functional only.

---

## 4. Firebase Architecture

### 4.1 Authentication

* Firebase Email/Password Authentication
* Users are created with status:

  * `pending`
  * `active`

Login is blocked in UI if status is `pending`.

---

### 4.2 Firestore Collections (MVP 1)

#### users

```
users/{userId}
{
  name: string,
  email: string,
  role: "customer" | "admin",
  status: "pending" | "active",
  totalPaid: number,
  balance: number,
  createdAt: timestamp
}
```

#### meals

```
meals/{mealId}
{
  userId: string,
  date: timestamp,
  foodName: string?,
  amount: number, // default 90
  approvedBy: adminId
}
```

#### payments

```
payments/{paymentId}
{
  userId: string,
  amount: number,
  method: "chapa",
  status: "success" | "failed",
  createdAt: timestamp
}
```

#### notifications

```
notifications/{notificationId}
{
  userId: string,
  type: "meal_approved" | "low_balance" | "meal_missed",
  message: string,
  createdAt: timestamp,
  read: boolean
}
```

---

## 5. Flutter Project Structure

Feature-first structure:

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   ├── controllers/
│   │   └── models/
│   ├── home/
│   ├── payments/
│   ├── notifications/
│   └── profile/
├── services/
│   ├── firebase_auth_service.dart
│   ├── firestore_service.dart
│   └── notification_service.dart
└── main.dart
```

---

## 6. Screen-by-Screen Implementation

### 6.1 Registration Screen

* Create Firebase Auth user
* Create Firestore `users` document
* Set status to `pending`

---

### 6.2 Login Screen

* Authenticate user
* Fetch Firestore user document
* Block access if status is `pending`

---

### 6.3 Home Screen

Display:

* Balance
* Total paid
* Days used
* Estimated remaining days

Data source:

* `users` collection
* `meals` collection

---

### 6.4 Payments Screen

* Integrate Chapa (or mock initially)
* Store payment in `payments` collection
* Update user balance

---

### 6.5 Notifications Screen

* Fetch user notifications
* Mark as read

---

### 6.6 Profile Screen

* Update profile info
* Change password

---

## 7. Admin Actions (Minimal UI)

### Approve User

* Update `users.status` to `active`
* Set `totalPaid` and `balance`

### Approve Daily Meal

* Create `meals` document
* Deduct amount from balance
* Create notification

---

## 8. Notifications Logic

### Meal Approved

* Triggered when admin approves meal

### Low Balance

* Triggered when balance < 50% of last payment

### Meal Missed

* Triggered if no meal entry exists for the day

---

## 9. Coding Rules

* Keep widgets small
* Avoid business logic in UI
* Reuse services
* Commit frequently
* Push working code only

---

## 10. Timeline & Focus

⏱ Deadline: **Tuesday Afternoon**

Focus order:

1. Auth & approval flow
2. Home screen
3. Meal approval
4. Notifications
5. Payments

---

## 11. Definition of Done

MVP 1 is complete when:

* Customer registration & approval works
* Balance updates correctly
* Notifications are delivered
* Payments are visible

---

**This document is the official developer reference for MealLink MVP 1.**
