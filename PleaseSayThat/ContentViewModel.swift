//
//  Untitled.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import Foundation
import SwiftUI
import Observation

// 표시할 화면의 종류를 정의하는 열거형
enum ViewScreen {
    case main          // 메인 홈 화면
    case createRoom    // 방 생성 화면
    case joinRoom      // 방 참여 화면
    case roomDetail(UUID) // 방 상세 화면 (UUID로 특정 방 식별)
}

@Observable
class ContentViewModel {
    // 현재 표시 중인 화면
    var currentScreen: ViewScreen = .main
    
    // 선택된 방 ID (필요한 경우)
    var selectedRoomId: UUID?
    
    // 사용자 관리자 참조
    private let userManager = UserManager.shared
    
    // 메인 화면으로 이동
    func navigateToMain() {
        currentScreen = .main
    }
    
    // 방 생성 화면으로 이동
    func navigateToCreateRoom() {
        currentScreen = .createRoom
    }
    
    // 방 참여 화면으로 이동
    func navigateToJoinRoom() {
        currentScreen = .joinRoom
    }
    
    // 특정 방 상세 화면으로 이동
    func navigateToRoomDetail(roomId: UUID) {
        selectedRoomId = roomId
        currentScreen = .roomDetail(roomId)
        userManager.updateLastAccessedRoom(roomId: roomId)
    }
    
    // 방 생성 기능
    func createRoom(name: String, maxMembers: Int) -> Bool {
        guard let currentUser = userManager.currentUser else {
            return false
        }
        
        // 새 방 생성
        let newRoom = Room(
            name: name,
            ownerId: currentUser.id,
            maximumMemberCount: maxMembers
        )
        
        // 사용자의 방 목록 업데이트
        userManager.addOwnedRoom(roomId: newRoom.id)
        userManager.addParticipatingRoom(roomId: newRoom.id)
        
        // 방 상세 화면으로 이동
        navigateToRoomDetail(roomId: newRoom.id)
        return true
    }
    
    // 방 참여 기능
    func joinRoom(with code: String) -> Bool {
        // 실제 구현에서는 방 코드를 검증하고 존재하는 방인지 확인합니다
        // 여기서는 간단히 UUID로 변환만 검증합니다
        guard let roomId = UUID(uuidString: code),
              let currentUser = userManager.currentUser else {
            return false
        }
        
        // 사용자의 참여 방 목록 업데이트
        userManager.addParticipatingRoom(roomId: roomId)
        
        // 방 상세 화면으로 이동
        navigateToRoomDetail(roomId: roomId)
        return true
    }
}
