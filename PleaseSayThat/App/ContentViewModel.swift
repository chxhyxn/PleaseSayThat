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
           let currentRoomId = currentUser.currentRoomId {
            // 사용자의, 마지막 접속한 방이 있으면 해당 방으로 이동
            selectedRoomId = currentRoomId
            currentScreen = .roomDetail(currentRoomId)
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
}
