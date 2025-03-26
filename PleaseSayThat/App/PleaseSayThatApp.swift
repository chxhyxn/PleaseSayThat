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
                    .frame(minWidth: 600, minHeight: 500)
            case .launched:
                ContentView()
                    .frame(minWidth: 600, minHeight: 500)
            }
        }
        .windowStyle(.titleBar)
    }
}
