import Foundation

/// Room entity representing a virtual space where multiple users can participate
struct Room: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the room
    let id: UUID
    
    /// Display name of the room
    var name: String
    
    /// ID of the room owner (has deletion privileges)
    let ownerId: UUID
    
    /// Current number of members in the room
    var currentMemberCount: Int
    
    /// Maximum capacity of the room
    var maximumMemberCount: Int
    
    /// List of user IDs currently in the room
    var currentMemberIds: [UUID]
    
    /// Current status of the room
    var currentStatus: RoomStatus
    
    // MARK: - Initialization
    
    /// Create a new room with default values
    init(id: UUID = UUID(),
         name: String,
         ownerId: UUID,
         currentMemberCount: Int = 0,
         maximumMemberCount: Int = 10,
         currentMemberIds: [UUID] = [],
         currentStatus: RoomStatus = .base) {
        
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.currentMemberIds = currentMemberIds
        self.currentMemberCount = currentMemberIds.count
        self.maximumMemberCount = maximumMemberCount
        self.currentStatus = currentStatus
        
        // Automatically add the owner to the members list if not already included
        if !currentMemberIds.contains(ownerId) {
            self.currentMemberIds.append(ownerId)
            self.currentMemberCount = self.currentMemberIds.count
        }
    }
}
