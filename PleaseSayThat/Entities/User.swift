import Foundation

/// User entity representing a participant in the application
struct User: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the user
    let id: UUID
    
    /// Username or display name
    var username: String
    
    /// List of room IDs the user is participating in
    var participatingRoomIds: [UUID]
    
    /// List of room IDs the user owns
    var ownedRoomIds: [UUID]
    
    /// ID of the last room the user accessed
    var currentRoomId: UUID?
    
    // MARK: - Initialization
    
    /// Create a new user with default values
    init(id: UUID = UUID(),
         username: String,
         participatingRoomIds: [UUID] = [],
         ownedRoomIds: [UUID] = [],
         currentRoomId: UUID? = nil) {
        self.id = id
        self.username = username
        self.participatingRoomIds = participatingRoomIds
        self.ownedRoomIds = ownedRoomIds
        self.currentRoomId = currentRoomId
    }
}
