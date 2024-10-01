
# Flutter Clean Architecture Overview

## Folder Structure

```text
lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── usecases/
│   └── util/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## Layers

1. **Core**: Contains code that is used across the entire application.
2. **Data**: Responsible for data retrieval and storage.
3. **Domain**: Contains business logic and defines the core functionality of the app.
4. **Presentation**: Handles UI and user interactions.

## Coding Standards

1. Use camelCase for variable and function names.
2. Use PascalCase for class names.
3. Add a comment describing each variable at the top of the file.
4. Add a function description comment at the start of each function.
5. Add a file description comment at the top of each file.
6. Use meaningful and descriptive names for variables, functions, and classes.
7. Keep functions small and focused on a single responsibility.
8. Use const and final keywords where appropriate.
9. Follow the DRY (Don't Repeat Yourself) principle.

## Example File Header

```dart
// File: example_file.dart
// Description: This file contains the ExampleClass which demonstrates...

import 'package:flutter/material.dart';

// Define constants and variables here
const int MAX_RETRY_COUNT = 3; // Maximum number of retry attempts

class ExampleClass {
  // Class implementation
}
```

## Example Function Documentation

```dart
/// Fetches user data from the API
///
/// Parameters:
/// - userId: The unique identifier of the user
///
/// Returns:
/// A Future that resolves to a User object if successful, or null if an error occurs
Future<User?> fetchUserData(String userId) async {
  // Function implementation
}
```

This overview provides a starting point for reorganizing the codebase. I'll now begin refactoring the existing code to fit this structure, starting with the core components.
