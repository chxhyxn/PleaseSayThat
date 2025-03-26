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
    
    @Published var listenerRegistration: ListenerRegistration?
    @Published var currentStatus: RoomStatus = .base
    @Published var roomName: String = ""

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
    
    func changeRoomStatus(
        currentRoomId: UUID,
        selectedStatus: RoomStatus,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Create a reference to the room document
        let roomRef = db.collection("rooms").document(currentRoomId.uuidString)
        
        // Update only the currentStatus field
        roomRef.updateData([
            "currentStatus": selectedStatus.rawValue
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Remove User from Room (방 나가기)
    /// 유저가 방에서 나가는 경우, 방의 멤버 리스트와 멤버 수를 업데이트합니다.
    ///
    /// - Parameters:
    ///   - roomId: 나가려는 방의 UUID
    ///   - userId: 방에서 나가려는 유저의 UUID
    ///   - completion: 성공 / 실패 결과를 반환할 클로저
    func removeUserFromRoom(
        roomId: UUID,
        userId: UUID,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let roomRef = db.collection("rooms").document(roomId.uuidString)
        
        roomRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot,
                  snapshot.exists,
                  var room = try? snapshot.data(as: Room.self) else {
                completion(.failure(RoomError.roomNotFound))
                return
            }
            
            // 현재 멤버에 해당 유저가 존재하는지 확인
            guard let index = room.currentMemberIds.firstIndex(of: userId) else {
                // 이미 없는 경우
                completion(.success(()))
                return
            }
            
            // 해당 유저 제거 후 멤버 수 업데이트
            room.currentMemberIds.remove(at: index)
            room.currentMemberCount = room.currentMemberIds.count
            
            do {
                let updatedData = try FirestoreEncoder().encode(room)
                roomRef.setData(updatedData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // room에 유저한명 추가하는 함수
    
    // from popoverview
    // Start listening for room status changes
    func startListening() {
        guard let currentUser = UserManager.shared.currentUser,
              let roomId = currentUser.currentRoomId else {
            print("no currentUser")
            return
        }
        
        print("엥", currentUser.id)
        print("엥", roomId)
        
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId.uuidString)
        
        // Set up real-time listener
        listenerRegistration = roomRef.addSnapshotListener { snapshot, error in
            guard let document = snapshot, document.exists,
                  let data = document.data() else {
                return
            }
            
            // Get room name
            if let name = data["name"] as? String {
                self.roomName = name
            }
            
            // Get current status
            if let statusString = data["currentStatus"] as? String,
               let status = RoomStatus(rawValue: statusString) {
                self.currentStatus = status
            } else {
                self.currentStatus = .base
            }
        }
    }
    
    // Stop listening when view disappears
    func stopListening() {
        listenerRegistration?.remove()
        self.currentStatus = .base
        self.roomName = ""
    }
    
    func refreshListening() {
        stopListening()
        startListening()
    }
    
    func addUserToRoom(
        roomId: UUID,
        userId: UUID,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let roomRef = db.collection("rooms").document(roomId.uuidString)
        
        // 1. Read the current room data
        roomRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists,
                  var room = try? snapshot.data(as: Room.self) else {
                completion(.failure(RoomError.roomNotFound))
                return
            }
            
            // 2. Check if the user is already in the room
            if room.currentMemberIds.contains(userId) {
                // User is already in the room; not necessarily an error.
                completion(.success(()))
                return
            }
            
            // 3. Check if the room is at capacity
            if room.currentMemberCount >= room.maximumMemberCount {
                completion(.failure(RoomError.roomIsFull))
                return
            }
            
            // 4. Add the user to the room
            room.currentMemberIds.append(userId)
            room.currentMemberCount = room.currentMemberIds.count
            
            // 5. Encode and write the updated room back to Firestore
            do {
                let updatedData = try FirestoreEncoder().encode(room)
                roomRef.setData(updatedData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum RoomError: Error {
    case roomNotFound
    case roomIsFull
}
