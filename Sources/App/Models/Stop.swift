//
//  Stop.swift
//  Caravan
//
//  Created by Zahra Cheeseman  on 2/1/25.
//

import Foundation

class Stop {
    private var location : (latitude: Double, longitude: Double)
    private var number : Int
    private var vehicle : Vehicle
    private var id : UUID
    var data_handler : DataHandler
    
    init (new_location : (latitude: Double, longitude: Double), stop_number : Int, vehicle : Vehicle, data_handler : DataHandler){
        location = new_location
        number = stop_number
        self.vehicle = vehicle
        id = UUID()
        self.data_handler = data_handler
    }
    
    func get_location() -> (latitude: Double, longitude: Double){
        return location
    }
    
    func get_number() -> Int{
        return number
    }
    
    func get_vehicle() -> Vehicle{
        return vehicle
    }
    
    func get_id() -> UUID{
        return id
    }
    
    func add_to_db(){
        data_handler.create_stop(stop: self)
    }
}
