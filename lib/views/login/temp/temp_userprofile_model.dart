import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';

class TempUserProfile {
  final String username;
  final String fullname;
  final String imageProfile;
  final DateTime lastLogin; // Added lastLogin field

  TempUserProfile({
    required this.username,
    required this.fullname,
    required this.imageProfile,
    required this.lastLogin,
  });

  // Convert JSON to TempUserProfile object
  factory TempUserProfile.fromJson(Map<String, dynamic> json) {
    return TempUserProfile(
      username: json['username'],
      fullname: json['fullname'],
      imageProfile: json['image_profile'],
      lastLogin: DateTime.parse(json['last_login']), // Parse date
    );
  }

  // Convert TempUserProfile object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'image_profile': imageProfile,
      'last_login': lastLogin.toIso8601String(),
    };
  }
}

//! CRUD Service
//! ===================================================================
class TempUserProfileStorage {
  final box = GetStorage();

  // Add or update user profile with last login time
  void addOrUpdateTempUserProfile(TempUserProfile profile) {
    List<dynamic> users = box.read('user_profiles') ?? [];
    int index = users.indexWhere((e) => e['username'] == profile.username);

    if (index == -1) {
      // New user, add to list
      users.add(profile.toJson());
    } else {
      // Existing user, update last login time
      users[index] = profile.toJson();
    }

    box.write('user_profiles', users);
  }

  // Read all user profiles
  List<TempUserProfile> getTempUserProfiles() {
    List<dynamic> users = box.read('user_profiles') ?? [];
    return users.map((e) => TempUserProfile.fromJson(e)).toList();
  }

  // Update only the last login time
  void updateLastLogin(String username, image_profile) {
    List<dynamic> users = box.read('user_profiles') ?? [];
    int index = users.indexWhere((e) => e['username'] == username);

    if (index != -1) {
      users[index]['last_login'] = DateTime.now().toIso8601String();
      users[index]['image_profile'] = image_profile;
      box.write('user_profiles', users);
    }
  }

  // Delete user profile
  void deleteTempUserProfile(String username) {
    List<dynamic> users = box.read('user_profiles') ?? [];
    users.removeWhere((e) => e['username'] == username);
    box.write('user_profiles', users);
  }

  // ✅ NEW FUNCTION: Get the Last Logged-in User
  TempUserProfile? getLastLoggedInUser() {
    List<TempUserProfile> users = getTempUserProfiles();
    if (users.isEmpty) return null;
    users.sort((a, b) => b.lastLogin.compareTo(a.lastLogin));
    return users.first;
  }

  TempUserProfile getUserByUsername(String username) {
    List<TempUserProfile> users = getTempUserProfiles();
    return users.firstWhere(
      (user) => user.username == username,
    );
  }
}
