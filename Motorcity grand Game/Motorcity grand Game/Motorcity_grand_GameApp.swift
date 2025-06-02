import SwiftUI

@main
struct Motorcity_grand_GameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MGRoot()
                .preferredColorScheme(.light)
        }
    }
}
