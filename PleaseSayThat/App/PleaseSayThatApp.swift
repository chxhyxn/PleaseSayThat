import SwiftUI

@main
struct PleaseSayThatApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var launchManager = LaunchManager.shared
    
    var body: some Scene {
        WindowGroup {
            switch launchManager.appState {
            case .loading:
                ProgressView()
                    .frame(width: 600, height: 500)
            case .launched:
                ContentView()
                    .frame(width: 600, height: 500)
                    .preferredColorScheme(.light)
            }
        }
        .windowStyle(.titleBar)
    }
}
