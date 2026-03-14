# Plexus NOC - Network Monitoring System

Plexus NOC is a high-performance, cross-platform mobile application developed with **Flutter** for real-time Network Operation Center (NOC) simulation. It provides network administrators with a comprehensive dashboard to monitor device health, track performance metrics, and receive instant status alerts, even with intermittent connectivity.

---

## 📖 Table of Contents
- [Core Features](#-core-features)
- [Technical Architecture](#-technical-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Test Credentials](#-test-credentials)

---

## ✨ Core Features

### 🔐 Secure Authentication
- User login with comprehensive form validation.
- Responsive design for both light and dark modes.

### 📊 Real-Time Dashboard
- **Live Metrics**: At-a-glance view of total devices, online/offline counts, and active alerts.
- **Dynamic Updates**: Simulated real-time data streaming (updates every few seconds).
- **Proactive Alerts**: Immediate UI notifications when a critical device goes offline.

### 🖥️ Device Management
- **Intelligent Search**: Filter devices by name, IP, or location in real-time.
- **Status Filtering**: Easily toggle between online and offline device views.
- **Detailed Insights**: Deep-dive into device-specific performance using interactive CPU and Memory charts.

### 💾 Robust Offline Support
- **Local Persistence**: Uses Hive for high-speed local data caching.
- **Seamless Recovery**: Automatically displays cached data when the network is unavailable.

---

## 🏗 Technical Architecture

The project follows **Clean Architecture** combined with the **BLoC (Business Logic Component)** pattern to ensure a scalable and testable codebase.

- **Presentation Layer**: Flutter widgets and BLoC for state management.
- **Domain Layer**: Pure Dart business logic (Entities, Use Cases, and Repository Interfaces).
- **Data Layer**: Data sources (Remote/Local) and Repository implementations.

### Dependency Injection
We use `GetIt` and `Injectable` for automated dependency injection, promoting loose coupling and easier unit testing.

---

## 🛠 Tech Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | Flutter |
| **State Management** | BLoC / Cubit |
| **Local Database** | Hive |
| **Networking** | Dio |
| **DI Container** | GetIt / Injectable |
| **Architecture** | Clean Architecture |
| **Testing** | Mocktail / Flutter Test |

---

## 📂 Project Structure

```text
lib/
├── core/                   # Cross-cutting concerns (Themes, DI, Errors, Network)
├── features/
│   ├── auth/               # User authentication logic and UI
│   ├── devices/            # Device listing, filtering, and real-time dashboard
│   └── splash/             # App initialization and branding
├── main.dart               # App entry point
└── injection_container.dart # Manual/Generated DI configuration
```

---

## 🏃 Getting Started

### Prerequisites
- Flutter SDK `^3.0.0`
- Dart SDK `^3.0.0`

### Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/salmanbashar1009/noc_task_plexus.git
    cd noc_task_plexus
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation:**
    The project uses `injectable_generator` for DI. Run the following to generate necessary files:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Launch the application:**
    ```bash
    flutter run
    ```

---

## 🧪 Development & Testing

### Running Tests
To execute the widget and unit test suite:
```bash
flutter test
```

### Static Analysis
Maintain code quality by running:
```bash
flutter analyze
```

---

## 🔑 Test Credentials

For demonstration and testing purposes, you can use the following:

- **Email:** `admin@plexus.com`
- **Password:** `password123`

---

## 👤 Maintainer
**Habibul Bashar**
