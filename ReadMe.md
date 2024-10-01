# StapesHome App

## Folder Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── api_routes.dart
│   │   ├── colors.dart
│   │   ├── config.dart
│   │   ├── font_sizes.dart
│   │   └── padding.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── util/
│       └── input_converter.dart
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── hive_local_datasource.dart
│   │   └── remote/
│   │       ├── auth_remote_datasource.dart
│   │       ├── device_remote_datasource.dart
│   │       ├── floor_remote_datasource.dart
│   │       ├── node_remote_datasource.dart
│   │       ├── room_remote_datasource.dart
│   │       └── websocket_remote_datasource.dart
│   ├── models/
│   │   ├── device_model.dart
│   │   ├── floor_model.dart
│   │   ├── node_model.dart
│   │   ├── room_model.dart
│   │   └── session_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── device_repository_impl.dart
│       ├── floor_repository_impl.dart
│       ├── node_repository_impl.dart
│       ├── room_repository_impl.dart
│       └── websocket_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── device.dart
│   │   ├── floor.dart
│   │   ├── node.dart
│   │   ├── room.dart
│   │   └── session.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── device_repository.dart
│   │   ├── floor_repository.dart
│   │   ├── node_repository.dart
│   │   ├── room_repository.dart
│   │   └── websocket_repository.dart
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── logout_usecase.dart
│       │   └── signup_usecase.dart
│       ├── device/
│       │   ├── create_device_usecase.dart
│       │   ├── delete_device_usecase.dart
│       │   ├── get_devices_usecase.dart
│       │   └── update_device_usecase.dart
│       ├── floor/
│       │   ├── create_floor_usecase.dart
│       │   ├── delete_floor_usecase.dart
│       │   ├── get_floors_usecase.dart
│       │   └── update_floor_usecase.dart
│       ├── node/
│       │   ├── create_node_usecase.dart
│       │   ├── delete_node_usecase.dart
│       │   ├── get_nodes_usecase.dart
│       │   └── update_node_usecase.dart
│       └── room/
│           ├── create_room_usecase.dart
│           ├── delete_room_usecase.dart
│           ├── get_rooms_usecase.dart
│           └── update_room_usecase.dart
│
├── presentation/
│   ├── bloc/
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── device/
│   │   │   ├── device_bloc.dart
│   │   │   ├── device_event.dart
│   │   │   └── device_state.dart
│   │   ├── floor/
│   │   │   ├── floor_bloc.dart
│   │   │   ├── floor_event.dart
│   │   │   └── floor_state.dart
│   │   ├── node/
│   │   │   ├── node_bloc.dart
│   │   │   ├── node_event.dart
│   │   │   └── node_state.dart
│   │   └── room/
│   │       ├── room_bloc.dart
│   │       ├── room_event.dart
│   │       └── room_state.dart
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   ├── signup_page.dart
│   │   │   └── forgot_password_page.dart
│   │   ├── device/
│   │   │   ├── devices_page.dart
│   │   │   └── add_device_page.dart
│   │   ├── floor/
│   │   │   ├── floors_page.dart
│   │   │   └── add_floor_page.dart
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── node/
│   │   │   ├── nodes_page.dart
│   │   │   ├── add_node_page.dart
│   │   │   └── node_provisioning_page.dart
│   │   ├── profile/
│   │   │   ├── profile_page.dart
│   │   │   └── edit_profile_page.dart
│   │   └── room/
│   │       ├── rooms_page.dart
│   │       └── add_room_page.dart
│   └── widgets/
│       ├── common/
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   └── custom_dropdown.dart
│       ├── device/
│       │   ├── device_list_item.dart
│       │   └── device_grid_item.dart
│       ├── floor/
│       │   └── floor_list_item.dart
│       ├── node/
│       │   └── node_list_item.dart
│       └── room/
│           └── room_list_item.dart
│
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
