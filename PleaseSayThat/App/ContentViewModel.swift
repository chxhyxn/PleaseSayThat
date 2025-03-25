//
//  ContentViewModel.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class ContentViewModel {
    // 현재 표시 중인 화면
    var currentScreen: ViewScreen = .main
    
    // 선택된 방 ID (필요한 경우)
    var selectedRoomId: UUID?
    
    // 사용자 관리자 참조
    private let userManager = UserManager.shared
    
    // 초기화 시 마지막 접속한 방 확인 및 설정
    init() {
        checkLastAccessedRoom()
    }
    
    // 마지막 접속한 방 확인 및 설정
    private func checkLastAccessedRoom() {
        if let currentUser = userManager.currentUser,
           let lastRoomId = currentUser.lastAccessedRoomId {
            // 사용자의, 마지막 접속한 방이 있으면 해당 방으로 이동
            selectedRoomId = lastRoomId
            currentScreen = .roomDetail(lastRoomId)
        }
    }
    
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
    
    // 사용 가능한 방 목록 가져오기 (실제 구현에서는 네트워크 요청 등을 통해 가져옵니다)
    func fetchAvailableRooms() async -> [AvailableRoom] {
        // 여기서는 샘플 데이터를 반환합니다
        // 실제 구현에서는 서버에서 데이터를 가져옵니다
        return [
            AvailableRoom(id: UUID(), name: "General Chat", memberCount: 8, maxMembers: 10),
            AvailableRoom(id: UUID(), name: "Game Night", memberCount: 4, maxMembers: 12),
            AvailableRoom(id: UUID(), name: "Study Group", memberCount: 3, maxMembers: 8),
            AvailableRoom(id: UUID(), name: "Coffee Break", memberCount: 5, maxMembers: 6),
            AvailableRoom(id: UUID(), name: "Movie Discussions", memberCount: 7, maxMembers: 15),
            AvailableRoom(id: UUID(), name: "Book Club", memberCount: 6, maxMembers: 10)
        ]
    }
}
