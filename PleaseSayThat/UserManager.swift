//
//  UserManager.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import Foundation
import Observation

/// Manager class to handle user operations and persistence
@Observable
class UserManager {
    // MARK: - Singleton
    
    /// Shared instance for singleton access
    static let shared = UserManager()
    
    /// Private initializer to enforce singleton pattern
    private init() {
        loadUser()
    }
    
    // MARK: - Properties
    
    /// Current user instance
    private(set) var currentUser: User?
    
    /// Key used for storing user data in UserDefaults
    private let userDefaultsKey = "com.app.userdata"
    
    // MARK: - User Management
    
    /// Initialize a new user with the provided information
    /// - Parameters:
    ///   - username: The username for the new user
    ///   - email: The email for the new user
    ///   - profileImageName: Optional profile image name
    /// - Returns: The newly created user
    @discardableResult
    func initializeUser(username: String, email: String, profileImageName: String? = nil) -> User {
        let newUser = User(
            username: username,
            email: email,
            profileImageName: profileImageName
        )
        
        self.currentUser = newUser
        saveUser()
        
        return newUser
    }
    
    /// Update the current user with new information
    /// - Parameter user: Updated user information
    func updateUser(_ user: User) {
        self.currentUser = user
        saveUser()
    }
    
    // MARK: - Persistence
    
    /// Save current user to UserDefaults
    func saveUser() {
        guard let user = currentUser else { return }
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    /// Load user from UserDefaults
    func loadUser() {
        guard let userData = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: userData)
            self.currentUser = user
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
        }
    }
    
    /// Delete current user data
    func deleteUserData() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
