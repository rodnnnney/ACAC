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
        // Load environment variables
        loadEnvironmentVariables()

        // Provide API keys from environment variables
        if let mapsAPIKey = ProcessInfo.processInfo.environment["GOOGLE_MAPS_API_KEY"] {
            GMSServices.provideAPIKey(mapsAPIKey)
        } else {
            fatalError("Google Maps API key not found in environment variables")
        }

        if let placesAPIKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_API_KEY"] {
            GMSPlacesClient.provideAPIKey(placesAPIKey)
        } else {
            fatalError("Google Places API key not found in environment variables")
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func loadEnvironmentVariables() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            fatalError(".env file not found in the app bundle")
        }

        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let envVars = content.components(separatedBy: .newlines)
            for envVar in envVars where !envVar.isEmpty {
                let keyValue = envVar.components(separatedBy: "=")
                if keyValue.count == 2 {
                    let key = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    setenv(key, value, 1)
                }
            }
        } catch {
            fatalError("Error loading .env file: \(error)")
        }
    }
}