// // lib/features/profile/presentation/bloc/profile_bloc.dart

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stapes_home/features/profile/domain/usecases/get_user_profile.dart';
// import 'profile_event.dart';
// import 'profile_state.dart';

// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   final GetUserProfile getUserProfile;
//   final UpdateUserProfile updateUserProfile;
//   final LogoutUser logoutUser;

//   ProfileBloc({
//     required this.getUserProfile,
//     required this.updateUserProfile,
//     required this.logoutUser,
//   }) : super(ProfileInitial()) {
//     on<LoadUserProfile>(_onLoadUserProfile);
//     on<UpdateUserProfileEvent>(_onUpdateUserProfileEvent);
//     on<LogoutUserEvent>(_onLogoutUserEvent);
//   }

//   void _onLoadUserProfile(
//       LoadUserProfile event, Emitter<ProfileState> emit) async {
//     emit(ProfileLoading());
//     try {
//       final profile = await getUserProfile.execute();
//       emit(ProfileLoaded(profile));
//     } catch (e) {
//       emit(ProfileError(e.toString()));
//     }
//   }

//   void _onUpdateUserProfileEvent(
//       UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
//     emit(ProfileLoading());
//     try {
//       await updateUserProfile.execute(event.profile);
//       emit(ProfileUpdated());
//       add(LoadUserProfile());
//     } catch (e) {
//       emit(ProfileError(e.toString()));
//     }
//   }

//   void _onLogoutUserEvent(
//       LogoutUserEvent event, Emitter<ProfileState> emit) async {
//     emit(ProfileLoading());
//     try {
//       await logoutUser.execute();
//       emit(LogoutSuccess());
//     } catch (e) {
//       emit(ProfileError(e.toString()));
//     }
//   }
// }