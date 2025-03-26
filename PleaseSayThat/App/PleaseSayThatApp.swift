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
//                    .frame(width: 726, height: 422)
            case .launched:
                ContentView()
//                    .frame(width: 726, height: 422)
                    .preferredColorScheme(.light)
            }
        }
        .windowStyle(.titleBar)
    }
}
