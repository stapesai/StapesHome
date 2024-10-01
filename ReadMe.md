# StapesHome App

## Folder Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── api_routes.dart
│   │   │   // Contains all API endpoint URLs
│   │   ├── colors.dart
│   │   │   // Defines color constants used throughout the app
│   │   ├── config.dart
│   │   │   // Holds configuration variables like environment settings
│   │   ├── font_sizes.dart
│   │   │   // Defines font size constants
│   │   └── padding.dart
│   │       // Defines padding constants
│   ├── error/
│   │   ├── exceptions.dart
│   │   │   // Custom exception classes
│   │   └── failures.dart
│   │       // Failure classes for domain layer
│   ├── network/
│   │   └── network_info.dart
│   │       // Provides network connectivity information
│   ├── usecases/
│   │   └── usecase.dart
│   │       // Abstract base class for use cases
│   └── util/
│       ├── input_converter.dart
│       │   // Utility for input validation and conversion
│       └── websocket_manager.dart
│           // Manages WebSocket connections and message handling
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── hive_local_datasource.dart
│   │   │       // Implements local data storage using Hive
│   │   └── remote/
│   │       ├── auth_remote_datasource.dart
│   │       │   // Handles authentication API calls
│   │       ├── device_remote_datasource.dart
│   │       │   // Manages device-related API calls
│   │       ├── floor_remote_datasource.dart
│   │       │   // Handles floor-related API calls
│   │       ├── mqtt_remote_datasource.dart
│   │       │   // Manages MQTT connections and message handling
│   │       ├── node_remote_datasource.dart
│   │       │   // Handles node-related API calls
│   │       ├── room_remote_datasource.dart
│   │       │   // Manages room-related API calls
│   │       └── websocket_remote_datasource.dart
│   │           // Handles WebSocket connections and real-time data
│   ├── models/
│   │   ├── device_model.dart
│   │   │   // Data model for devices
│   │   ├── floor_model.dart
│   │   │   // Data model for floors
│   │   ├── mqtt_message_model.dart
│   │   │   // Data model for MQTT messages
│   │   ├── node_model.dart
│   │   │   // Data model for nodes
│   │   ├── room_model.dart
│   │   │   // Data model for rooms
│   │   ├── session_model.dart
│   │   │   // Data model for user sessions
│   │   └── websocket_message_model.dart
│   │       // Data model for WebSocket messages
│   └── repositories/
│       ├── auth_repository_impl.dart
│       │   // Implementation of AuthRepository
│       ├── device_repository_impl.dart
│       │   // Implementation of DeviceRepository
│       ├── floor_repository_impl.dart
│       │   // Implementation of FloorRepository
│       ├── mqtt_repository_impl.dart
│       │   // Implementation of MQTTRepository
│       ├── node_repository_impl.dart
│       │   // Implementation of NodeRepository
│       ├── room_repository_impl.dart
│       │   // Implementation of RoomRepository
│       └── websocket_repository_impl.dart
│           // Implementation of WebSocketRepository
│
├── domain/
│   ├── entities/
│   │   ├── device.dart
│   │   │   // Entity class for devices
│   │   ├── floor.dart
│   │   │   // Entity class for floors
│   │   ├── mqtt_message.dart
│   │   │   // Entity class for MQTT messages
│   │   ├── node.dart
│   │   │   // Entity class for nodes
│   │   ├── room.dart
│   │   │   // Entity class for rooms
│   │   ├── session.dart
│   │   │   // Entity class for user sessions
│   │   └── websocket_message.dart
│   │       // Entity class for WebSocket messages
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   │   // Abstract class defining authentication operations
│   │   ├── device_repository.dart
│   │   │   // Abstract class defining device operations
│   │   ├── floor_repository.dart
│   │   │   // Abstract class defining floor operations
│   │   ├── mqtt_repository.dart
│   │   │   // Abstract class defining MQTT operations
│   │   ├── node_repository.dart
│   │   │   // Abstract class defining node operations
│   │   ├── room_repository.dart
│   │   │   // Abstract class defining room operations
│   │   └── websocket_repository.dart
│   │       // Abstract class defining WebSocket operations
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   │   // Use case for user login
│       │   ├── logout_usecase.dart
│       │   │   // Use case for user logout
│       │   └── signup_usecase.dart
│       │       // Use case for user signup
│       ├── device/
│       │   ├── create_device_usecase.dart
│       │   │   // Use case for creating a new device
│       │   ├── delete_device_usecase.dart
│       │   │   // Use case for deleting a device
│       │   ├── get_devices_usecase.dart
│       │   │   // Use case for fetching devices
│       │   └── update_device_usecase.dart
│       │       // Use case for updating a device
│       ├── floor/
│       │   ├── create_floor_usecase.dart
│       │   │   // Use case for creating a new floor
│       │   ├── delete_floor_usecase.dart
│       │   │   // Use case for deleting a floor
│       │   ├── get_floors_usecase.dart
│       │   │   // Use case for fetching floors
│       │   └── update_floor_usecase.dart
│       │       // Use case for updating a floor
│       ├── mqtt/
│       │   ├── connect_mqtt_usecase.dart
│       │   │   // Use case for connecting to MQTT broker
│       │   ├── disconnect_mqtt_usecase.dart
│       │   │   // Use case for disconnecting from MQTT broker
│       │   ├── publish_mqtt_message_usecase.dart
│       │   │   // Use case for publishing MQTT messages
│       │   └── subscribe_mqtt_topic_usecase.dart
│       │       // Use case for subscribing to MQTT topics
│       ├── node/
│       │   ├── create_node_usecase.dart
│       │   │   // Use case for creating a new node
│       │   ├── delete_node_usecase.dart
│       │   │   // Use case for deleting a node
│       │   ├── get_nodes_usecase.dart
│       │   │   // Use case for fetching nodes
│       │   └── update_node_usecase.dart
│       │       // Use case for updating a node
│       ├── room/
│       │   ├── create_room_usecase.dart
│       │   │   // Use case for creating a new room
│       │   ├── delete_room_usecase.dart
│       │   │   // Use case for deleting a room
│       │   ├── get_rooms_usecase.dart
│       │   │   // Use case for fetching rooms
│       │   └── update_room_usecase.dart
│       │       // Use case for updating a room
│       └── websocket/
│           ├── connect_websocket_usecase.dart
│           │   // Use case for establishing WebSocket connection
│           ├── disconnect_websocket_usecase.dart
│           │   // Use case for closing WebSocket connection
│           └── send_websocket_message_usecase.dart
│               // Use case for sending WebSocket messages
│
├── presentation/
│   ├── bloc/
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   │   // BLoC for managing authentication state
│   │   │   ├── auth_event.dart
│   │   │   │   // Events for auth_bloc
│   │   │   └── auth_state.dart
│   │   │       // States for auth_bloc
│   │   ├── device/
│   │   │   ├── device_bloc.dart
│   │   │   │   // BLoC for managing device state
│   │   │   ├── device_event.dart
│   │   │   │   // Events for device_bloc
│   │   │   └── device_state.dart
│   │   │       // States for device_bloc
│   │   ├── floor/
│   │   │   ├── floor_bloc.dart
│   │   │   │   // BLoC for managing floor state
│   │   │   ├── floor_event.dart
│   │   │   │   // Events for floor_bloc
│   │   │   └── floor_state.dart
│   │   │       // States for floor_bloc
│   │   ├── mqtt/
│   │   │   ├── mqtt_bloc.dart
│   │   │   │   // BLoC for managing MQTT connection state
│   │   │   ├── mqtt_event.dart
│   │   │   │   // Events for mqtt_bloc
│   │   │   └── mqtt_state.dart
│   │   │       // States for mqtt_bloc
│   │   ├── node/
│   │   │   ├── node_bloc.dart
│   │   │   │   // BLoC for managing node state
│   │   │   ├── node_event.dart
│   │   │   │   // Events for node_bloc
│   │   │   └── node_state.dart
│   │   │       // States for node_bloc
│   │   ├── room/
│   │   │   ├── room_bloc.dart
│   │   │   │   // BLoC for managing room state
│   │   │   ├── room_event.dart
│   │   │   │   // Events for room_bloc
│   │   │   └── room_state.dart
│   │   │       // States for room_bloc
│   │   └── websocket/
│   │       ├── websocket_bloc.dart
│   │       │   // BLoC for managing WebSocket connection state
│   │       ├── websocket_event.dart
│   │       │   // Events for websocket_bloc
│   │       └── websocket_state.dart
│   │           // States for websocket_bloc
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   │   // Login page UI
│   │   │   ├── signup_page.dart
│   │   │   │   // Signup page UI
│   │   │   └── forgot_password_page.dart
│   │   │       // Forgot password page UI
│   │   ├── device/
│   │   │   ├── devices_page.dart
│   │   │   │   // Page displaying list of devices
│   │   │   └── add_device_page.dart
│   │   │       // Page for adding a new device
│   │   ├── floor/
│   │   │   ├── floors_page.dart
│   │   │   │   // Page displaying list of floors
│   │   │   └── add_floor_page.dart
│   │   │       // Page for adding a new floor
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   │       // Main home page of the app
│   │   ├── node/
│   │   │   ├── nodes_page.dart
│   │   │   │   // Page displaying list of nodes
│   │   │   ├── add_node_page.dart
│   │   │   │   // Page for adding a new node
│   │   │   └── node_provisioning_page.dart
│   │   │       // Page for node provisioning process
│   │   ├── profile/
│   │   │   ├── profile_page.dart
│   │   │   │   // User profile page
│   │   │   └── edit_profile_page.dart
│   │   │       // Page for editing user profile
│   │   └── room/
│   │       ├── rooms_page.dart
│   │       │   // Page displaying list of rooms
│   │       └── add_room_page.dart
│   │           // Page for adding a new room
│   └── widgets/
│       ├── common/
│       │   ├── custom_button.dart
│       │   │   // Reusable custom button widget
│       │   ├── custom_text_field.dart
│       │   │   // Reusable custom text field widget
│       │   └── custom_dropdown.dart
│       │       // Reusable custom dropdown widget
│       ├── device/
│       │   ├── device_list_item.dart
│       │   │   // Widget for displaying a device in a list
│       │   └── device_grid_item.dart
│       │       // Widget for displaying a device in a grid
│       ├── floor/
│       │   └── floor_list_item.dart
│       │       // Widget for displaying a floor in a list
│       ├── node/
│       │   └── node_list_item.dart
│       │       // Widget for displaying a node in a list
│       └── room/
│           └── room_list_item.dart
│               // Widget for displaying a room in a list
│
└── main.dart
    // Entry point of the application, sets up dependency injection and initial route
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
