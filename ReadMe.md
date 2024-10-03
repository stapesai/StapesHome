# StapesHome App

## Folder Structure

```text
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── constants/
│   │   └── api_routes.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── http_client.dart - Client for making HTTP requests (with logging and error handling)
│   │   └── network_info.dart - Checks network connectivity
│   ├── theme/
│   │   ├── app_colors.dart - Contains colors constants used in the app
│   │   ├── app_fonts.dart - Contains fonts and text styles used in the app
│   │   └── app_padding.dart - Constant page padding 
│   ├── utils/
│   │   ├── input_converter.dart
│   │   └── logger.dart
│   └── success/
│       └── success.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── hive_local_datasource.dart
│   │   └── remote/
│   │       ├── auth_remote_datasource.dart
│   │       ├── device_remote_datasource.dart
│   │       ├── floor_remote_datasource.dart
│   │       ├── room_remote_datasource.dart
│   │       ├── node_remote_datasource.dart
│   │       └── user_remote_datasource.dart
│   ├── models/
│   │   ├── device_model.dart
│   │   ├── floor_model.dart
│   │   ├── room_model.dart
│   │   ├── node_model.dart
│   │   ├── user_model.dart
│   │   └── session_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── device_repository_impl.dart
│       ├── floor_repository_impl.dart
│       ├── room_repository_impl.dart
│       ├── node_repository_impl.dart
│       └── user_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── device.dart
│   │   ├── floor.dart
│   │   ├── room.dart
│   │   ├── node.dart
│   │   ├── user.dart
│   │   └── session.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── device_repository.dart
│   │   ├── floor_repository.dart
│   │   ├── room_repository.dart
│   │   ├── node_repository.dart
│   │   └── user_repository.dart
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── signup_usecase.dart
│       │   ├── verify_otp_usecase.dart
│       │   └── reset_password_usecase.dart
│       ├── device/
│       │   ├── get_devices_usecase.dart
│       │   ├── toggle_device_usecase.dart
│       │   └── add_device_usecase.dart
│       ├── floor/
│       │   ├── get_floors_usecase.dart
│       │   ├── add_floor_usecase.dart
│       │   └── delete_floor_usecase.dart
│       ├── room/
│       │   ├── get_rooms_usecase.dart
│       │   ├── add_room_usecase.dart
│       │   └── delete_room_usecase.dart
│       ├── node/
│       │   ├── get_nodes_usecase.dart
│       │   ├── add_node_usecase.dart
│       │   └── provision_node_usecase.dart
│       └── user/
│           └── get_user_details_usecase.dart
├── presentation/
│   ├── blocs/
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
│   │   ├── room/
│   │   │   ├── room_bloc.dart
│   │   │   ├── room_event.dart
│   │   │   └── room_state.dart
│   │   ├── node/
│   │   │   ├── node_bloc.dart
│   │   │   ├── node_event.dart
│   │   │   └── node_state.dart
│   │   └── user/
│   │       ├── user_bloc.dart
│   │       ├── user_event.dart
│   │       └── user_state.dart
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   ├── signup_page.dart
│   │   │   ├── otp_verification_page.dart
│   │   │   └── forgot_password_page.dart
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── devices/
│   │   │   ├── devices_page.dart
│   │   │   └── add_device_page.dart
│   │   ├── floors/
│   │   │   └── create_floor_page.dart
│   │   ├── rooms/
│   │   │   └── create_room_page.dart
│   │   ├── nodes/
│   │   │   ├── nodes_page.dart
│   │   │   ├── add_node_page.dart
│   │   │   ├── node_provisioning_page.dart
│   │   │   └── qr_scanner_page.dart
│   │   ├── profile/
│   │   │   ├── profile_page.dart
│   │   │   ├── edit_profile_page.dart
│   │   │   └── sessions_page.dart
│   │   └── splash_screen.dart
│   └── widgets/
│       ├── buttons/
│       │   ├── custom_button.dart
│       │   └── scan_node_add_device_button.dart
│       ├── dialogs/
│       │   ├── logout_confirmation_dialog.dart
│       │   └── delete_confirmation_dialog.dart
│       ├── input/
│       │   ├── custom_text_field.dart
│       │   ├── password_text_field.dart
│       │   └── custom_dropdown.dart
│       ├── iot/
│       │   ├── light_component.dart
│       │   ├── fan_component.dart
│       │   └── node_component.dart
│       ├── selectors/
│       │   └── floor_room_selector.dart
│       └── skeletons/
│           ├── device_skeleton.dart
│           ├── floor_room_name_skeleton.dart
│           └── node_skeleton.dart
├── services/
│   └── websocket_service.dart
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
