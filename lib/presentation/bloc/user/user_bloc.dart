// File: lib/presentation/bloc/user_bloc.dart
// Description: This file contains the UserBloc, which manages the state of user-related operations.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/update_user_profile.dart';
import '../../../core/usecases/usecase.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserEvent extends UserEvent {}

class UpdateUserProfileEvent extends UserEvent {
  final User user;

  const UpdateUserProfileEvent(this.user);

  @override
  List<Object> get props => [user];
}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUser getCurrentUser;
  final UpdateUserProfile updateUserProfile;

  UserBloc({
    required this.getCurrentUser,
    required this.updateUserProfile,
  }) : super(UserInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onGetCurrentUser(GetCurrentUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) => emit(UserError(failure.toString())),
      (user) => emit(UserLoaded(user)),
    );
  }

  void _onUpdateUserProfile(UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await updateUserProfile(UpdateUserProfileParams(user: event.user));
    result.fold(
      (failure) => emit(UserError(failure.toString())),
      (success) {
        if (success) {
          emit(UserLoaded(event.user));
        } else {
          emit(const UserError('Failed to update user profile'));
        }
      },
    );
  }
}
