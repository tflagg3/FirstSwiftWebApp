//
//  User.swift
//  Caravan
//
//  Created by Zahra Cheeseman  on 1/25/25.
//

import Foundation

class User : Equatable{
    
    private var user_id: UUID
    private var email: String = ""
    private var phone_number: String = ""
//
//    private var username: String = ""
//    private var name: String = ""
//    private var password: String = ""
//    private var friends: [User] = []
//    private var current_vehicle : Vehicle? = nil
//    private var trip_history : [TripSession] = []
    
    private var data_handler: DataHandler
    
    //creating an empty User from scratch
    // ask yunus
    init(existing_data_handler : DataHandler){
        data_handler = existing_data_handler
        user_id = UUID()
        
    }
    
    //retrieving a current user
    // ask yunus
    init(existing_user_id : UUID,
         existing_email : String,
         existing_phone : String,
         existing_data_handler : DataHandler){
        
        data_handler = existing_data_handler
        user_id = existing_user_id
        email = existing_email
        phone_number = existing_phone
    }
    
    func get_user_id() -> UUID{
        return user_id
    }
    
//    func get_name() -> String{
//        return name
//    }
//
//
//    func get_username() -> String{
//        return username
//    }
//
//    func get_friend_list() -> [User]{
//        return friends
//    }
//
//
//    func get_trip_history() -> [TripSession]{
//        return trip_history
//    }
//
//    func update_username(new_username : String){
//        username = new_username
//        data_handler.update_username(user: self, new_username: new_username)
//    }
//
//    func update_email(new_email : String){
//        email = new_email
//        data_handler.update_email(user: self, new_email: new_email)
//    }
//
//    func get_location(){
//
//    }
//
//    func update_vehicle(vehicle : Vehicle){
//
//        current_vehicle = vehicle
//        data_handler.update_user_vehicle(id: user_id, vehicle: vehicle)
//
//    }
//
//    func upload_photo(){
//
//    }
//
//    func get_photo(){
//
//    }
//
//    func send_friend_request(receiver_id : UUID){
//
//        data_handler.create_friend_request(sender_id: user_id, receiver_id: receiver_id)
//
//    }
//
//    func remove_friend(user : User){
//
//        if let index = friends.firstIndex(of: user){
//            friends.remove(at: index)
//        }
//
//        data_handler.delete_friendship(user_1_id: user_id, user_2_id: user.get_user_id())
//    }
        
    //users are the same if they have the same user_id
    static func == (lhs: User, rhs: User) -> Bool {
            return lhs.user_id == rhs.user_id
        }
    
    
}
