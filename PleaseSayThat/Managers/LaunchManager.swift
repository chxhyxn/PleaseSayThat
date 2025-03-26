import Foundation
import Observation
import OSLog

/// Manager class to handle user operations and persistence
final class LaunchManager: ObservableObject {
    // MARK: - Singleton
    
    static let shared = LaunchManager()
    
    private init() {}
    
    @Published var appState: AppState = .loading
}
