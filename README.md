
# 🌈 Moo’d – Your Mood Matters

## 🧠 Inspiration

Moo’d was created to support mental wellness through personalized check-ins and mood tracking. Inspired by the simplicity of self-care and the power of community, Moo’d gamifies emotional reflection and provides a safe space for users to express themselves and grow. With a light-hearted theme and the charm of a digital cow companion, it turns emotional well-being into an engaging journey.

---

## 📱 Overview

**Moo’d** is a mobile mental health application built with **SwiftUI** and **Firebase**, designed to help users track their emotions, complete wellness check-ins, and monitor their progress through dynamic dashboards and playful incentives. The app transforms emotional self-care into a fun and rewarding experience with an adorable pet cow that grows with you.

---

## 🚀 Features

- 🧑‍💼 **User Profiles** – Collect and store names, pronouns, and preferences for a tailored user experience.
- 🧠 **Emotional Surveys** – Step-by-step questionnaires to assess users' current mood and mental state.
- 📊 **Dynamic Dashboard** – Visualize progress and score summaries tied to wellness categories like stress, anxiety, and energy.
- 🎁 **Rewards System** – Earn points through daily check-ins and redeem them for digital items to customize the cow companion.
- 💬 **Quote of the Day** – Get inspired with a daily motivational or calming message.
- 🐮 **Pet Companion** – A customizable digital cow with skins, outfits, and accessories that respond to progress and engagement.
- 🌐 **Firebase Integration** – Real-time user authentication, Firestore data storage, and notification updates.
- 🔔 **Notifications** – Personalized reminders for check-ins, point milestones, and more.
- 🔎 **Analytics** – View and reflect on mood trends, goals, and achievements.
- 🌿 **Goal Setting** – Set personal growth targets and track progress with interactive goal views.

---

## 🏗️ Architecture

- **Frontend:** SwiftUI, Swift 5  
- **Backend:** Firebase Authentication, Firestore, FirebaseManager for secure data handling  
- **State Management:** ObservableObject with StoreData and PetCustomization models  
- **Navigation:** NavigationStack with modular views (Home, Login, Survey, Pet, Goals, Resources, Analytics, etc.)  
- **Design Assets:** Custom illustrations (including cow images and accessory sets), vector logos (`logosamp`, `cow`, etc.)

---

## 🧪 Development Status

🚧 **Moo’d** is in active development with core features like surveys, profile customization, Firebase integration, and point tracking implemented. Future updates will include:
- Complete Google OAuth error handling.
- Enhanced animations and UI polish.
- Expanded wellness check-ins with tailored questions.
- Deeper insights and mood-based content recommendations.
- Improved accessibility and localization support.

---


## 🔐 Security & Privacy

- User data (name, email, phone) is securely stored in Firestore.
- Authentication via Firebase supports Email and Google Sign-In with proper Firestore document IDs.
- Data transmission complies with App Transport Security (ATS) requirements.
- Sensitive data such as scores and notifications are protected and updated securely.

---


## 🏃‍♀️ How to Run

1. Clone the repository.
2. Open `MoodApp.xcodeproj` in Xcode.
3. Set up a Firebase project and download `GoogleService-Info.plist`.
4. Replace the placeholder Firebase configuration in Xcode with your own.
5. Build and run the app on a simulator or a real device.

---
