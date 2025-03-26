import Foundation
import Observation
import OSLog

/// Manager class to handle user operations and persistence
@Observable
class UserManager {
    // MARK: - Singleton
    
    /// Shared instance for singleton access
    static let shared = UserManager()
    
    /// Private initializer to enforce singleton pattern
    private init() {
        logger.notice("Resetting UserDefaults before loading user")
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        logger.debug("UserManager initializing...")
        loadUser()
    }
    
    // MARK: - Properties
    
    /// Current user instance
    private(set) var currentUser: User?
    
    /// Key used for storing user data in UserDefaults
    private let userDefaultsKey = "com.app.userdata"
    
    /// Logger for tracking operations
    private let logger = Logger(subsystem: "com.app.PleaseSayThat", category: "UserManager")
    
    // MARK: - User Management
    
    /// Initialize a new user with the provided information
    /// - Parameters:
    ///   - username: The username for the new user
    /// - Returns: The newly created user
    @discardableResult
    func initializeUser(username: String) -> User {
        logger.info("Initializing new user with username: \(username)")
        
        let newUser = User(
            username: username
        )
        
        self.currentUser = newUser
        saveUser()
        
        logger.info("User initialized successfully with ID: \(newUser.id.uuidString)")
        return newUser
    }
    
    /// Create a default user with randomized name
    /// - Returns: The newly created default user
    private func createDefaultUser() -> User {
        let randomNumber = Int.random(in: 1000...9999)
        let defaultUsername = "User\(randomNumber)"
        
        logger.notice("Creating default user with generated username: \(defaultUsername)")
        return initializeUser(username: defaultUsername)
    }
    
    /// Update the current user with new information
    /// - Parameter user: Updated user information
    func updateUser(_ user: User) {
        logger.info("Updating user with ID: \(user.id.uuidString)")
        self.currentUser = user
        saveUser()
    }
    
    /// Add a room ID to the user's participating rooms
    /// - Parameter roomId: The room ID to add
    func addParticipatingRoom(roomId: UUID) {
        guard var user = currentUser else {
            logger.error("Cannot add participating room: No current user")
            return
        }
        
        if !user.participatingRoomIds.contains(roomId) {
            logger.info("Adding room \(roomId.uuidString) to user's participating rooms")
            user.participatingRoomIds.append(roomId)
            self.currentUser = user
            saveUser()
        } else {
            logger.info("Room \(roomId.uuidString) already in user's participating rooms list")
        }
    }
    
    /// Add a room ID to the user's owned rooms
    /// - Parameter roomId: The room ID to add
    func addOwnedRoom(roomId: UUID) {
        guard var user = currentUser else {
            logger.error("Cannot add owned room: No current user")
            return
        }
        
        if !user.ownedRoomIds.contains(roomId) {
            logger.info("Adding room \(roomId.uuidString) to user's owned rooms")
            user.ownedRoomIds.append(roomId)
            self.currentUser = user
            saveUser()
        } else {
            logger.info("Room \(roomId.uuidString) already in user's owned rooms list")
        }
    }
    
    /// Update the last accessed room ID
    /// - Parameter roomId: The room ID that was last accessed
    func updateLastAccessedRoom(roomId: UUID) {
        guard var user = currentUser else {
            logger.error("Cannot update last accessed room: No current user")
            return
        }
        
        logger.info("Updating last accessed room to \(roomId.uuidString)")
        user.currentRoomId = roomId
        self.currentUser = user
        saveUser()
    }
    
    // MARK: - Persistence
    
    /// Save current user to UserDefaults
    func saveUser() {
        guard let user = currentUser else {
            logger.warning("Cannot save user data: No current user")
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
            logger.debug("User data saved successfully")
        } catch {
            logger.error("Error saving user data: \(error.localizedDescription)")
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    /// Load user from UserDefaults or create a default user if none exists
    func loadUser() {
        logger.debug("Attempting to load user data from UserDefaults")
        
        guard let userData = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            logger.notice("No user data found in UserDefaults")
            // No user data found, create a default user
            _ = createDefaultUser()
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: userData)
            self.currentUser = user
            
            // Log detailed user information
            logger.info("====== Existing User Loaded Successfully ======")
            logger.info("User ID: \(user.id.uuidString)")
            logger.info("Username: \(user.username)")
            logger.info("Participating in \(user.participatingRoomIds.count) rooms")
            logger.info("Owns \(user.ownedRoomIds.count) rooms")
            
            if let currentRoomId = user.currentRoomId {
                logger.info("current room ID: \(currentRoomId.uuidString)")
            } else {
                logger.info("No last accessed room")
            }
            
            // Log room IDs if they exist
            if !user.participatingRoomIds.isEmpty {
                logger.debug("Participating room IDs: \(user.participatingRoomIds.map { $0.uuidString }.joined(separator: ", "))")
            }
            
            if !user.ownedRoomIds.isEmpty {
                logger.debug("Owned room IDs: \(user.ownedRoomIds.map { $0.uuidString }.joined(separator: ", "))")
            }
            
            logger.info("==============================================")
        } catch {
            logger.error("Error decoding user data: \(error.localizedDescription)")
            print("Error loading user data: \(error.localizedDescription)")
            // If decoding fails, create a default user
            _ = createDefaultUser()
        }
    }
    
    /// Delete current user data
    func deleteUserData() {
        logger.notice("Deleting user data")
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        logger.info("User data deleted successfully")
    }
}
