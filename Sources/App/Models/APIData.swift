//
//  FriendRequestAPI.swift
//  FirstWebApp
//
//  Created by Tanner Flagg on 1/29/25.
//

import Foundation
import Vapor

struct FriendRequestAPI: Decodable {
    var sender_id: UUID
    var receiver_id: UUID
}

struct StartTripAPI: Decodable {
    var start_lat: String
    var start_long: String
    var dest_lat: String
    var dest_long: String
    var trip_leader_ID: UUID
    var trip_name: String
    var trip_start: String
    var trip_end: String
}

struct UpdateLocationAPI: Decodable {
    var vehicle_id: UUID
    var my_lat: String
    var my_long: String
}

struct AddStopAPI: Decodable {
    var vehicle_id: UUID
    var stop_lat: String
    var stop_long: String
    var stop_num: Int
}
