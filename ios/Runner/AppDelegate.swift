import UIKit
import Flutter
import GoogleMaps
import GooglePlaces

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Provide your actual API keys here
        GMSPlacesClient.provideAPIKey("AIzaSyAI-ybP5FH1HG9N9UNZkFqVyGZSkAWEsW4")
        GMSServices.provideAPIKey("AIzaSyAI-ybP5FH1HG9N9UNZkFqVyGZSkAWEsW4")

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}







