//
//  TripSession.swift
//  Caravan
//
//  Created by Zahra Cheeseman  on 1/25/25.
//

import Foundation

class TripSession{
    
    private var name : String
    private var session_id : UUID
    //private var notifications : [CaravanNotification] = []
    private var vehicles : [Vehicle] = []
    private var trip_leader : User
    private var session_code : String
    private var end_location : (latitude: Double, longitude: Double)
    private var start_location : (latitude: Double, longitude: Double)
    private var completed : Bool = false
    private var start_time : Date
    private var end_time : Date
    
    var data_handler : DataHandler
    
    //var group_chats : [GroupChat] = []
    
    //creating a trip session from scratch
    init(
         start : (latitude: Double, longitude: Double),
         destination : (latitude: Double, longitude: Double),
         set_trip_leader : User,
         set_trip_name : String,
         proposed_start_time : Date,
         proposed_end_time : Date,
         
         existing_data_handler : DataHandler

    ){
        func generate_session_code(length: Int) -> String {
          let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        
        session_id = UUID()
        data_handler = existing_data_handler
        
        start_location = start
        end_location = destination
        trip_leader = set_trip_leader
        session_code = generate_session_code(length: 6)
        name = set_trip_name
        start_time = proposed_start_time
        end_time = proposed_end_time
    }
    
    //create a object of TripSession from an existing session in the db
    init(
        existing_trip_name : String,
        existing_session_id : UUID,
        //existing_notifications : [CaravanNotification],
        existing_vehicles : [Vehicle],
        existing_trip_leader : User,
        existing_session_code : String,
        existing_start_location : (latitude: Double, longitude: Double),
        existing_end_location : (latitude: Double, longitude: Double),
        existing_start_time : Date,
        existing_end_time : Date,
        existing_data_handler : DataHandler//this will be self
        

    ){
        name = existing_trip_name
        session_id = existing_session_id
        //notifications = existing_notifications
        vehicles = existing_vehicles
        trip_leader = existing_trip_leader
        session_code = existing_session_code
        start_location = existing_start_location
        end_location = existing_end_location
        data_handler = existing_data_handler
        start_time = existing_start_time
        end_time = existing_end_time
        
    }
    
    func create_trip_session_in_db(){
        data_handler.create_trip_session(trip_session: self)
    }
    
    func invite_member(invited_member : User) -> Bool{
        return true
    }
    
    func get_vehicles() -> [Vehicle]{
        return vehicles
    }
    
    func get_session_id() -> UUID {
        return session_id
    }
    
    func get_completed() -> Bool{
        return completed
    }
    
    func get_start_location() -> (latitude: Double, longitude: Double){
        return start_location
    }
    
    func get_end_location() -> (latitude: Double, longitude: Double){
        return end_location
    }
    
    func get_trip_leader() -> User {
        return trip_leader
    }
    
    func get_name() -> String {
        return name
    }
    
    func get_start_time() -> Date{
        return start_time
    }
    
    func get_end_time() -> Date{
        return end_time
    }
    
    func get_session_code () -> String {
        return session_code
    }
    
    func set_name( new_name: String) {
            self.name = new_name
    }
        
    func set_trip_leader(new_trip_leader: User) {
        self.trip_leader = new_trip_leader
    }
    
    func set_session_code(new_session_code: String) {
        self.session_code = new_session_code
    }
    
    func set_end_location(latitude: Double, longitude: Double) {
        self.end_location = (latitude, longitude)
    }
    
    func set_start_location(latitude: Double, longitude: Double) {
        self.start_location = (latitude, longitude)
    }
    
    func set_completed(is_completed: Bool) {
        self.completed = is_completed
    }
    
    func set_start_time(new_start_time: Date) {
        self.start_time = new_start_time
    }
    
    func set_end_time(new_end_time: Date) {
        self.end_time = new_end_time
    }
        
    
    func get_riders() -> [User]{
        var all_riders : [User] = []
        //goes into every vehicle and gets their riders
        for vehicle in vehicles{
            all_riders.append(contentsOf: vehicle.get_riders())
        }
        //returns a list of riders
        return all_riders
    }
    

    
}
