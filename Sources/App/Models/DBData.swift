//
//  DBData.swift
//  Caravan
//
//  Created by Zahra Cheeseman  on 1/28/25.
//

import Foundation


struct DBUser : Encodable, Decodable{
    
    let id : UUID
    let email : String
    let phone_number : String
    
}
struct Friendship : Encodable {
    
    let id : UUID
    let created_at : Date
    let user_1 : UUID
    let user_2 : UUID
}

struct FriendRequest : Encodable, Decodable{
    
    let id : UUID
    let created_at : Date
    let sender : UUID
    let receiver : UUID
}

struct Trip : Encodable, Decodable{
    
    let id : UUID
    let start_time : Date
    let end_time : Date
    let start_location : String//GeoJsonSource?)
    let end_location : String //?
    let trip_leader : UUID
    let completed : Bool
    let name : String
    let session_code : String
}

struct TripOutput : Decodable{
    let id : UUID
    let start_time : String
    let end_time : String
    let start_location : String//GeoJsonSource?)
    let end_location : String //?
    let trip_leader : UUID
    let completed : Bool
    let name : String
    let session_code : String
}

struct DBVehicle : Encodable, Decodable {
    //DBVehicle as Vehicle class already defined
    let id : UUID
    let trip_id : UUID
    let driver_id : UUID
    let name : String
}

struct VehicleMembership : Encodable, Decodable {
    
    let id : UUID
    let vehicle_id : UUID
    let user_id : UUID
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct DBStop : Encodable, Decodable {
    let id : UUID
    let vehicle_id : UUID
    let location : String
    let stop_number : Int
}
