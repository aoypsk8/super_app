import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:super_app/widget/textfont.dart';

class BiometricAuthScreen extends StatefulWidget {
  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  String _authMessage = "Not authenticated";

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  /// ✅ Check if the device supports biometrics
  Future<void> _checkBiometrics() async {
    bool canCheck = false;
    List<BiometricType> availableBiometrics = [];

    try {
      canCheck = await _localAuth.canCheckBiometrics;
      availableBiometrics = await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print("Error checking biometrics: $e");
    }

    setState(() {
      _isBiometricAvailable = canCheck;
      _availableBiometrics = availableBiometrics;
    });

    print("Available Biometrics: $_availableBiometrics");
  }

  /// ✅ Authenticate the user using biometrics
  Future<void> _authenticate() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: "Authenticate to login.",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (e) {
      print("Biometric authentication error: $e");
    }

    setState(() {
      _authMessage = isAuthenticated ? "✅ Authentication Successful" : "❌ Authentication Failed";
    });

    if (!isAuthenticated) {
      await _recheckBiometrics(); // ✅ Try again after failure
    } else {
      await _checkBiometrics(); // ✅ Re-check biometrics after successful authentication
    }
  }

  /// ✅ Re-check Biometrics (Useful when switching between Fingerprint & Face ID)
  Future<void> _recheckBiometrics() async {
    await Future.delayed(Duration(seconds: 1));
    _checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextFont(text: "Biometric Authentication")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFont(
              text: _isBiometricAvailable ? "✅ Biometrics Available" : "❌ Biometrics Not Available",
              maxLines: 2,
            ),
            SizedBox(height: 10),
            TextFont(
              text: "Available: ${_availableBiometrics.map((b) => b.toString()).join(', ')}",
              maxLines: 2,
            ),
            SizedBox(height: 20),
            TextFont(
              text: _authMessage,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _authenticate,
              child: TextFont(text: "Authenticate with Biometrics"),
            ),
          ],
        ),
      ),
    );
  }
}
