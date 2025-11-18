# GEMINI.md

## Project Overview

This is a Flutter project named "diary". It appears to be a mobile application that has features for different user roles, including a client and an admin. The app uses Supabase for its backend, suggesting it has features for authentication and data storage. The UI is built with Flutter, and it uses `go_router` for navigation, `provider` for state management, and `pluto_grid` for displaying data in grids. The app also supports localization.

## Building and Running

### Prerequisites

*   Flutter SDK: Make sure you have the Flutter SDK installed.
*   Environment Variables: The project uses a `.env` file for environment variables. Create a `.env` file in the root of the project and add the following variables:
    *   `SUPABASE_URL`: Your Supabase project URL.
    *   `SUPABASE_ANON_KEY`: Your Supabase anonymous key.

### Commands

*   **Install dependencies:**
    ```bash
    flutter pub get
    ```
*   **Run the app:**
    ```bash
    flutter run
    ```
*   **Build the app:**
    ```bash
    flutter build <platform>
    ```
    Replace `<platform>` with your target platform (e.g., `apk`, `appbundle`, `ios`).

## Development Conventions

*   **State Management:** The project uses the `provider` package for state management.
*   **Navigation:** The project uses the `go_router` package for navigation.
*   **Localization:** The project uses the `flutter_localizations` package and `.arb` files for localization.
*   **Code Style:** The project uses `flutter_lints` to enforce good coding practices. The lint rules are defined in the `analysis_options.yaml` file.
*   **Assets:** Assets are stored in the `assets` directory.
*   **Routing:** Routes are defined in the `lib/router.dart` file.
*   **Entry Point:** The main entry point of the application is `lib/main.dart`.
