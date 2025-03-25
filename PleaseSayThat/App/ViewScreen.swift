//
//  ViewScreen.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 표시할 화면의 종류를 정의하는 열거형
enum ViewScreen {
    case main          // 메인 홈 화면
    case createRoom    // 방 생성 화면
    case joinRoom      // 방 참여 화면
    case roomDetail(UUID) // 방 상세 화면 (UUID로 특정 방 식별)
}
