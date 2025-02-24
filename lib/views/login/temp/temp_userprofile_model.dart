import 'package:get_storage/get_storage.dart';

//! Model
//! ===================================================================
class TempUserProfile {
  final String username;
  final String fullname;
  final String imageProfile;

  TempUserProfile({
    required this.username,
    required this.fullname,
    required this.imageProfile,
  });

  // Convert JSON to TempUserProfile object
  factory TempUserProfile.fromJson(Map<String, dynamic> json) {
    return TempUserProfile(
      username: json['username'],
      fullname: json['fullname'],
      imageProfile: json['image_profile'],
    );
  }

  // Convert TempUserProfile object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'image_profile': imageProfile,
    };
  }
}

//! CRUD Service
//! ===================================================================
class TempUserProfileStorage {
  final box = GetStorage();
  void addTempUserProfile(TempUserProfile profile) {
    List<dynamic> users = box.read('user_profiles') ?? [];
    bool exists = users.any((e) => e['username'] == profile.username);

    if (!exists) {
      users.add(profile.toJson());
      box.write('user_profiles', users);
    } else {
      print('User already exists'); // Handle user feedback here
    }
  }

  // Read all user profiles
  List<TempUserProfile> getTempUserProfiles() {
    List<dynamic> users = box.read('user_profiles') ?? [];
    return users.map((e) => TempUserProfile.fromJson(e)).toList();
  }

  // Update user profile
  void updateTempUserProfile(String username, TempUserProfile updatedProfile) {
    List<dynamic> users = box.read('user_profiles') ?? [];
    int index = users.indexWhere((e) => e['username'] == username);
    if (index != -1) {
      users[index] = updatedProfile.toJson();
      box.write('user_profiles', users);
    }
  }

  // Delete user profile
  void deleteTempUserProfile(String username) {
    List<dynamic> users = box.read('user_profiles') ?? [];
    users.removeWhere((e) => e['username'] == username);
    box.write('user_profiles', users);
  }
}
