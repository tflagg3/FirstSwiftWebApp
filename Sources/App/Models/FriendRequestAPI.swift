//
//  FriendRequestAPI.swift
//  FirstWebApp
//
//  Created by Tanner Flagg on 1/29/25.
//

import Foundation
import Vapor

struct FriendRequestAPI: Content {
    var sender_id: UUID
    var receiver_id: UUID
}
