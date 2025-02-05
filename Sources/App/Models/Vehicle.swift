//
//  Vehicle.swift
//  Caravan
//
//  Created by Zahra Cheeseman  on 1/25/25.
//

import Foundation

class Vehicle: Equatable{
    
    private var vehicle_id : UUID
    private var name : String
    private var riders : [User]
    private var stops : [Stop] = []
    private var current_driver : User
    private var session_id : UUID
    private var last_location : (latitude: Double, longitude: Double) = (0,0)

    
    private var data_handler : DataHandler
    
    //create a vehicle from scratch
    init(
        vehicle_name : String,
        vehicle_driver : User,
        current_session: TripSession,
        existing_data_handler : DataHandler
    ){
        name = vehicle_name
        riders = [vehicle_driver]
        current_driver = vehicle_driver
        vehicle_id = UUID()
        session_id = current_session.get_session_id()
        data_handler = existing_data_handler
    }
    
    //vehicles are the same if they have the same vehicle_id
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
            return lhs.vehicle_id == rhs.vehicle_id
        }
    
    func update_driver(new_driver : User) -> Bool{
        
        if new_driver == current_driver{
            //change to new_driver.get_name()
            print(new_driver.get_user_id(), " is already the driver of this vehicle!")
            return true
        }
        
        else if riders.contains(new_driver){
            //change to new_driver.get_name()
            current_driver = new_driver
            data_handler.update_vehicle(vehicle: self, field_to_update: "current_driver")
            return true
        }
        
        else{
            print(new_driver.get_user_id(), " is not in the vehicle!")
            return false
        }
        
    }
    
    func add_stop(){
        
    }
    
    func get_vehicle_id() -> UUID{
        return vehicle_id
    }
    
    func get_stops() -> [Stop] {
        return stops
    }
    
    func get_riders() -> [User]{
        return riders
    }
    
    func get_name() -> String{
        return name
    }
    
    func get_driver() -> User{
        return current_driver
    }
    
    func get_session_id() -> UUID{
        return session_id
    }
    
    func update_riders(rider : User, action : String) -> Bool{
        
        if action == "add"{
            riders.append(rider)
            //add vehicle in db
            //create vehicle membership
            data_handler.create_vehicle_membership(rider: rider, existing_vehicle : self)
            return true
            
        }
        
        else if action == "remove"{
            if let index = riders.firstIndex(of: rider){
                riders.remove(at : index)
            }
            //delete vehicle membership
            data_handler.delete_vehicle_membership(rider: rider, vehicle : self)
            return true
        }
        else{
            print("Unable to perform update")
            return false
        }
        
        
    }
    
}
