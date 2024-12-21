# StapesHome App

## Folder Structure

```text
lib
├── core
│   ├── common
│   │   ├── bloc
│   │   ├── skeletons
│   │   └── widgets
│   │       ├── button.dart
│   │       ├── input
│   │       │   ├── dropdown.dart
│   │       │   ├── password.dart
│   │       │   └── textfield.dart
│   │       ├── iot
│   │       ├── popup.dart
│   │       ├── snackbar.dart
│   │       └── text_hyperlink.dart
│   ├── config
│   │   └── config.dart
│   ├── constants
│   │   ├── api_routes.dart
│   │   ├── app_route_constants.dart
│   │   └── logging_constants.dart
│   ├── database
│   │   └── sqlite_service.dart
│   ├── error
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── logging
│   │   ├── custom_logger.dart
│   │   └── logging_config.dart
│   ├── models
│   │   ├── device_model.dart
│   │   ├── fav_devices_model.dart
│   │   ├── floor_model.dart
│   │   ├── no_params.dart
│   │   ├── node_model.dart
│   │   ├── room_model.dart
│   │   ├── user_model.dart
│   │   ├── user_model.g.dart
│   │   ├── user_session_model.dart
│   │   └── user_session_model.g.dart
│   ├── network
│   │   ├── dio_client.dart
│   │   ├── dio_interceptors.dart
│   │   ├── http_client.dart
│   │   └── network_info.dart
│   ├── router
│   │   └── app_router.dart
│   ├── theme
│   │   ├── app_colors.dart
│   │   ├── app_font_sizes.dart
│   │   ├── app_padding.dart
│   │   └── custom_gradient_and_padding_container.dart
│   ├── usecase
│   │   └── usecase.dart
│   ├── utils
│   │   └── repository_exceptions_helper.dart
│   ├── validators
│   │   ├── date_validator.dart
│   │   └── email_regex_validator.dart
│   └── websocket
│       ├── websocket_bloc.dart
│       ├── websocket_event.dart
│       ├── websocket_messages_models.dart
│       ├── websocket_service.dart
│       └── websocket_state.dart
├── features
│   ├── auth
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   ├── device_info_local_datasource.dart
│   │   │   │   │   └── fcm_token_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       ├── auth_remote_datasource.dart
│   │   │   │       └── fcm_token_remote_datasource.dart
│   │   │   ├── models
│   │   │   │   ├── device_info_model.dart
│   │   │   │   ├── fcm_token_api_params.dart
│   │   │   │   ├── forgot_password_api_parms.dart
│   │   │   │   ├── login_api_parms.dart
│   │   │   │   ├── otp_verification_api_parms.dart
│   │   │   │   └── signup_api_parms.dart
│   │   │   └── repositories
│   │   │       ├── auth_abs_class_impl.dart
│   │   │       ├── device_info_abs_class_impl.dart
│   │   │       └── fcm_token_repo_abs_class_impl.dart
│   │   ├── domain
│   │   │   ├── repository
│   │   │   │   ├── auth_abs_class.dart
│   │   │   │   ├── device_info_abs_class.dart
│   │   │   │   └── fcm_token_repo_abs_class.dart
│   │   │   └── usecases
│   │   │       ├── device_info_usecase.dart
│   │   │       ├── fcm_token_usecase.dart
│   │   │       ├── forgot_password_usecase.dart
│   │   │       ├── login_usecase.dart
│   │   │       ├── otp_verification_usecase.dart
│   │   │       └── signup_usecase.dart
│   │   └── presentation
│   │       ├── blocs
│   │       │   ├── forgot_password
│   │       │   │   ├── forgot_password_email_input_bloc.dart
│   │       │   │   ├── forgot_password_email_input_event.dart
│   │       │   │   ├── forgot_password_email_input_state.dart
│   │       │   │   ├── forgot_password_otp_verification_bloc.dart
│   │       │   │   ├── forgot_password_otp_verification_event.dart
│   │       │   │   ├── forgot_password_otp_verification_state.dart
│   │       │   │   ├── forgot_password_reset_password_bloc.dart
│   │       │   │   ├── forgot_password_reset_password_event.dart
│   │       │   │   └── forgot_password_reset_password_state.dart
│   │       │   ├── login
│   │       │   │   ├── login_email_input_bloc.dart
│   │       │   │   ├── login_email_input_event.dart
│   │       │   │   ├── login_email_input_state.dart
│   │       │   │   ├── login_otp_verification_bloc.dart
│   │       │   │   ├── login_otp_verification_event.dart
│   │       │   │   └── login_otp_verification_state.dart
│   │       │   └── signup
│   │       │       ├── sign_up_email_input_bloc.dart
│   │       │       ├── sign_up_email_input_event.dart
│   │       │       ├── sign_up_email_input_state.dart
│   │       │       ├── signup_create_new_password_bloc.dart
│   │       │       ├── signup_create_new_password_event.dart
│   │       │       ├── signup_create_new_password_state.dart
│   │       │       ├── signup_details_form_bloc.dart
│   │       │       ├── signup_details_form_event.dart
│   │       │       ├── signup_details_form_state.dart
│   │       │       ├── signup_otp_verification_bloc.dart
│   │       │       ├── signup_otp_verification_event.dart
│   │       │       └── signup_otp_verification_state.dart
│   │       ├── pages
│   │       │   ├── forgot_password_email_input.dart
│   │       │   ├── forgot_password_otp_verification.dart
│   │       │   ├── forgot_password_reset_password.dart
│   │       │   ├── login_email_input.dart
│   │       │   ├── login_otp_verification.dart
│   │       │   ├── signup_create_new_password.dart
│   │       │   ├── signup_details_form.dart
│   │       │   ├── signup_email_input.dart
│   │       │   └── signup_otp_verification.dart
│   │       └── widgets
│   │           └── otp_input_widget.dart
│   ├── common
│   │   └── presentation
│   │       └── widgets
│   │           ├── hold_bottom_sheet_widget.dart
│   │           ├── iot
│   │           │   ├── fan_widget.dart
│   │           │   ├── light_widget.dart
│   │           │   └── node_widget.dart
│   │           └── skeletons
│   │               ├── iot_device_skel.dart
│   │               └── node_skel.dart
│   ├── dev
│   │   ├── data
│   │   └── presentation
│   │       ├── pages
│   │       │   ├── dev_components_test_page.dart
│   │       │   ├── dev_floor_room_sel.dart
│   │       │   ├── dev_test_page.dart
│   │       │   ├── dev_user_details_show.dart
│   │       │   └── dev_websocket_messages_test.dart
│   │       └── widgets
│   │           └── websocket_message.dart
│   ├── devices
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   └── devices_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       └── devices_remote_datasource.dart
│   │   │   ├── models
│   │   │   │   ├── create_device_api_param.dart
│   │   │   │   ├── delete_device_api_param.dart
│   │   │   │   ├── get_devices_api_param.dart
│   │   │   │   └── update_device_api_param.dart
│   │   │   └── repositories
│   │   │       └── devices_repository_impl.dart
│   │   ├── domain
│   │   │   ├── repositories
│   │   │   │   └── devices_repository.dart
│   │   │   └── usecases
│   │   │       ├── create_device_usecase.dart
│   │   │       ├── delete_device_usecase.dart
│   │   │       ├── get_all_devices_usecase.dart
│   │   │       ├── get_devices_by_node_id_usecase.dart
│   │   │       ├── get_devices_by_room_id_usecase.dart
│   │   │       └── update_device_usecase.dart
│   │   └── presentation
│   │       └── pages
│   │           └── devices.dart
│   ├── fav_devices
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   └── fav_device_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       └── fav_device_remote_datasource.dart
│   │   │   ├── models
│   │   │   │   ├── create_fav_devices_api_params.dart
│   │   │   │   ├── delete_fav_devices_api_params.dart
│   │   │   │   └── get_fav_devices_api_params.dart
│   │   │   └── repositories
│   │   │       └── fav_device_repository_impl.dart
│   │   └── domain
│   │       ├── repositories
│   │       │   └── fav_device_repository.dart
│   │       └── usecases
│   │           ├── create_fav_devices.dart
│   │           ├── get_fav_devices.dart
│   │           └── remove_fav_devices.dart
│   ├── floor_room_sel
│   │   └── presentation
│   │       ├── bloc
│   │       │   ├── floor
│   │       │   │   ├── floor_bloc.dart
│   │       │   │   ├── floor_event.dart
│   │       │   │   └── floor_state.dart
│   │       │   ├── floor_room_sel_bloc.dart
│   │       │   ├── floor_room_sel_event.dart
│   │       │   ├── floor_room_sel_state.dart
│   │       │   └── room
│   │       │       ├── room_bloc.dart
│   │       │       ├── room_event.dart
│   │       │       └── room_state.dart
│   │       ├── skeletons
│   │       │   └── floor_room_name_skel.dart
│   │       └── widgets
│   │           ├── floor_room_name_button.dart
│   │           ├── floor_room_sel_widget.dart
│   │           └── plus_button.dart
│   ├── floors
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   └── floors_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       └── floors_remote_datasource.dart
│   │   │   ├── models
│   │   │   │   ├── create_floor_api_param.dart
│   │   │   │   ├── delete_floor_api_param.dart
│   │   │   │   ├── get_floors_api_param.dart
│   │   │   │   └── update_floor_api_param.dart
│   │   │   └── repositories
│   │   │       └── floor_repository_impl.dart
│   │   ├── domain
│   │   │   ├── repository
│   │   │   │   └── floor_repository.dart
│   │   │   └── usecases
│   │   │       ├── create_floor_usecase.dart
│   │   │       ├── delete_floor_usecase.dart
│   │   │       ├── get_floors_usecase.dart
│   │   │       └── update_floor_usecase.dart
│   │   └── presentation
│   │       ├── bloc
│   │       │   ├── create_floor_bloc.dart
│   │       │   ├── create_floor_event.dart
│   │       │   ├── create_floor_state.dart
│   │       │   ├── delete_floor_bloc.dart
│   │       │   ├── delete_floor_event.dart
│   │       │   ├── delete_floor_state.dart
│   │       │   ├── edit_floor_bloc.dart
│   │       │   ├── edit_floor_event.dart
│   │       │   └── edit_floor_state.dart
│   │       ├── pages
│   │       │   └── create_floor_page.dart
│   │       └── widgets
│   │           ├── create_floor_widget.dart
│   │           ├── delete_floor_widget.dart
│   │           └── edit_floor_widget.dart
│   ├── home
│   │   └── presentation
│   │       └── pages
│   │           └── home.dart
│   ├── iot_provisioning
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   ├── ble_local_datasource.dart
│   │   │   │   │   └── wifi_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       └── .gitkeep
│   │   │   ├── models
│   │   │   │   └── node_hw_info.dart
│   │   │   └── repository
│   │   │       └── iot_provisioning_repo_imp.dart
│   │   ├── domain
│   │   │   ├── repository
│   │   │   │   └── iot_provisioning_repo.dart
│   │   │   └── usecase
│   │   │       ├── iot_provisioning_ble_check_wifi_credentials.dart
│   │   │       ├── iot_provisioning_ble_get_hw_info.dart
│   │   │       ├── iot_provisioning_ble_pair_node.dart
│   │   │       ├── iot_provisioning_ble_upload_config.dart
│   │   │       └── iot_provisioning_wifi_get_available_nwtworks.dart
│   │   └── presentation
│   │       ├── bloc
│   │       │   ├── iot_provisioning_bloc.dart
│   │       │   ├── iot_provisioning_event.dart
│   │       │   └── iot_provisioning_state.dart
│   │       ├── old
│   │       │   ├── enter_wifi_credentials.dart
│   │       │   ├── name_your_node.dart
│   │       │   ├── provisioning.dart
│   │       │   ├── select_node_options.dart
│   │       │   └── wifi_credentials.dart
│   │       ├── pages
│   │       │   └── iot_provisioning.dart
│   │       └── widgets
│   │           ├── enter_wifi_cred.dart
│   │           ├── name_your_node.dart
│   │           └── select_node_location.dart
│   ├── navigation
│   │   ├── data
│   │   ├── domain
│   │   └── presentation
│   │       ├── blocs
│   │       │   ├── navigation_bloc.dart
│   │       │   ├── navigation_event.dart
│   │       │   └── navigation_state.dart
│   │       ├── mixin
│   │       │   ├── keep_alive_mixin.dart
│   │       │   └── preload_page_view_mixin.dart
│   │       ├── pages
│   │       │   └── navigation_screen.dart
│   │       └── widgets
│   │           └── custom_navigation_bar.dart
│   ├── nodes
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   └── nodes_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       └── nodes_remote_datasource.dart
│   │   │   ├── models
│   │   │   │   ├── complete_node_pairing_api_param.dart
│   │   │   │   ├── delete_node_api_param.dart
│   │   │   │   ├── get_nodes_by_room_id_api_param.dart
│   │   │   │   ├── request_node_pairing_api_param.dart
│   │   │   │   └── update_node_api_param.dart
│   │   │   └── repositories
│   │   │       └── node_repository_impl.dart
│   │   ├── domain
│   │   │   ├── repository
│   │   │   │   └── node_repository.dart
│   │   │   └── usecases
│   │   │       ├── delete_node_usecase.dart
│   │   │       ├── get_nodes_by_room_id_usecase.dart
│   │   │       ├── pair_node_usecase.dart
│   │   │       └── update_node_usecase.dart
│   │   └── presentation
│   │       └── pages
│   │           └── nodes.dart
│   ├── onboarding
│   │   ├── data
│   │   ├── domain
│   │   └── presentation
│   │       ├── bloc
│   │       └── pages
│   │           └── splash_screen.dart
│   ├── rooms
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   └── rooms_local_datasource.dart
│   │   │   │   └── remote
│   │   │   │       └── rooms_remote_datasource.dart
│   │   │   ├── models
│   │   │   │   ├── create_room_api_param.dart
│   │   │   │   ├── delete_room_api_param.dart
│   │   │   │   ├── get_rooms_api_param.dart
│   │   │   │   └── update_room_api_param.dart
│   │   │   └── repositories
│   │   │       └── room_repository_impl.dart
│   │   ├── domain
│   │   │   ├── repository
│   │   │   │   └── room_repository.dart
│   │   │   └── usecases
│   │   │       ├── create_room_usecase.dart
│   │   │       ├── delete_room_usecase.dart
│   │   │       ├── get_rooms_usecase.dart
│   │   │       └── update_room_usecase.dart
│   │   └── presentation
│   │       ├── bloc
│   │       │   ├── create_room_bloc.dart
│   │       │   ├── create_room_event.dart
│   │       │   ├── create_room_state.dart
│   │       │   ├── delete_room_bloc.dart
│   │       │   ├── delete_room_event.dart
│   │       │   ├── delete_room_state.dart
│   │       │   ├── edit_room_bloc.dart
│   │       │   ├── edit_room_event.dart
│   │       │   └── edit_room_state.dart
│   │       ├── pages
│   │       │   └── create_room_page.dart
│   │       └── widgets
│   │           ├── create_room_widget.dart
│   │           ├── delete_room_widget.dart
│   │           └── edit_room_widget.dart
│   ├── scanner
│   │   ├── data
│   │   │   └── models
│   │   │       ├── pair_iot_node_qr_model.dart
│   │   │       ├── pair_tv_qr_model.dart
│   │   │       └── parse_qr_data_model.dart
│   │   └── presentation
│   │       ├── bloc
│   │       │   ├── qr_scanner_bloc.dart
│   │       │   ├── qr_scanner_event.dart
│   │       │   └── qr_scanner_state.dart
│   │       ├── pages
│   │       │   └── qr_scanner.dart
│   │       └── widgets
│   │           ├── scan_instructions.dart
│   │           └── scanner_overlay.dart
│   ├── settings
│   │   ├── data
│   │   ├── domain
│   │   └── presentation
│   └── tv_provisioning
│       └── presentation
│           └── pages
│               └── tv_provisioning.dart
├── firebase_options.dart
├── main.dart
└── service_locator.dart
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
