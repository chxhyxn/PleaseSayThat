import SwiftUI
import Firebase
import FirebaseFirestore

/// Singleton manager responsible for room-related Firestore operations
final class RoomManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = RoomManager()
    private init() { }
    
    // MARK: - Firestore reference
    private let db = Firestore.firestore()
    
    // MARK: - Create Room
    /// Creates a new room in Firestore.
    ///
    /// - Parameters:
    ///   - name: The display name of the room.
    ///   - ownerId: The owner's UUID (who will also be automatically added to the room's members).
    ///   - maximumMemberCount: The maximum number of members allowed in the room.
    ///   - completion: A closure called upon completion of the Firestore operation. Returns a `Result<Room, Error>`.
    func createRoom(
        name: String,
        ownerId: UUID,
        maximumMemberCount: Int = 10,
        completion: @escaping (Result<Room, Error>) -> Void
    ) {
        // 1. Create a new Room object
        let newRoom = Room(
            name: name,
            ownerId: ownerId,
            maximumMemberCount: maximumMemberCount
        )
        
        // 2. Convert the Room object to [String: Any] for Firestore
        do {
            let roomData = try FirestoreEncoder().encode(newRoom)
            
            // 3. Write to Firestore using the room's UUID as the document ID
            db.collection("rooms")
                .document(newRoom.id.uuidString)
                .setData(roomData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(newRoom))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }
}
