# Cazuela Chapina - Flutter Client (skeleton)

This is a starter Flutter client that consumes your existing .NET Minimal API at `http://10.0.2.2:5266/api` (Android emulator) or `http://localhost:5266/api` for web.

## Features implemented (skeleton)
- List products (tamales, bebidas, combos)
- View combos (shows product names)
- Create simple sale (venta) with offline queue using SharedPreferences
- Fetch product attributes and allow selections
- LLM ask via backend (`/api/llm/ask`)

## How to use

1. Ensure your .NET API is running at http://localhost:5266/
2. If using Android emulator, from the app use `API_BASE = "http://10.0.2.2:5266/api"`; for iOS simulator use `http://localhost:5266/api`.
3. From this folder run:
   ```bash
   flutter pub get
   flutter run
   ```

## Project structure
- lib/
  - main.dart
  - services/api_service.dart
  - models/
  - pages/
  - widgets/

This is a functional skeleton. Expand UI/validation and error handling as needed.
