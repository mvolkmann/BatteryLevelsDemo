import SwiftUI

/*
 It may not be possible to get the battery level of an associated Apple Watch
 from an iOS app. See
 https://stackoverflow.com/questions/53154389/determine-apple-watch-battery-level-from-paired-iphone.
 and
 https://medium.com/@gohnjanotis/apple-watch-battery-level-charging-notifications-eb7d0797a4d8

 You can get notifications on iPhone when watch is fully charged.
 To enable this, launch the Watch app on the iPhone,
 select "Sleep", and enable "Charging Reminders".
 It may also be necessary to enable sleep tracking in the Health app.
 How can a SwiftUI app listen for these notifications?
 */
class BatteryViewModel: ObservableObject {
    @Published var level = 0

    // Other values include .unplugged, .charging, and .full.
    @Published var state: UIDevice.BatteryState = .unknown

    var description: String {
        switch state {
        case .unknown:
            return "unknown"
        case .unplugged:
            return "unplugged"
        case .charging:
            return "charging"
        case .full:
            return "full"
        @unknown default:
            return "unknown"
        }
    }

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        level = Int(UIDevice.current.batteryLevel * 100)
        state = UIDevice.current.batteryState

        // Apparently WatchKit is only available in watchOS.
        // let watchLevel = WKInterfaceDevice.current().batteryLevel
        // print("watchLevel =", watchLevel)

        addObservers()
    }

    @MainActor
    @objc func batteryLevelDidChange() {
        level = Int(UIDevice.current.batteryLevel * 100)
    }

    @MainActor
    @objc func batteryStateDidChange() {
        state = UIDevice.current.batteryState
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
    }
}
