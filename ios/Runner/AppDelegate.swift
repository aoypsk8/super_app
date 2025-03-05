import UIKit
import Flutter
import Darwin

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let deviceChannel = FlutterMethodChannel(name: "device_info_channel",
                                              binaryMessenger: controller.binaryMessenger)
    
    deviceChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "getDeviceDetails" {
            let deviceName = self.getDeviceName() // Retrieve user-set iPhone name
            result([
                "deviceName": deviceName,
                "deviceModel": UIDevice.current.model,
                "systemVersion": UIDevice.current.systemVersion,
                "deviceID": UIDevice.current.identifierForVendor?.uuidString ?? "Unknown",
                "hardwareModel": self.getDeviceModel()
            ])
        } else {
            result(FlutterMethodNotImplemented)
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// ✅ Correct way to retrieve the user-set iPhone name on iOS
  func getDeviceName() -> String {
      return ProcessInfo.processInfo.hostName // Fix for iOS
  }

  /// Get the hardware model (e.g., "iPhone15,2" for iPhone 14 Pro)
  func getDeviceModel() -> String {
      var size = 0
      sysctlbyname("hw.machine", nil, &size, nil, 0)
      var machine = [CChar](repeating: 0, count: size)
      sysctlbyname("hw.machine", &machine, &size, nil, 0)
      return String(cString: machine)
  }
}