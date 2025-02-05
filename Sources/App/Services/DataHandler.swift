//
//  DataHandler.swift
//  Caravan
//
//  Created by Zahra Cheeseman  on 1/25/25.
//

import Foundation
import Supabase

class DataHandler{
    
    
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://hailzstmrievssxdfizb.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhaWx6c3RtcmlldnNzeGRmaXpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc3NDM2NDQsImV4cCI6MjA1MzMxOTY0NH0.DyXxiOTh3zyrkaWUdb0PTjfgqNhVG06OtVsD5rJ_Tdg")
    
    func create_new_user(){
        // Talk to Yunus to see if this is included in authentication frontend somewhere, think about moving it here?
        // should return a User Object if successful?
    }
    
    func get_user_profile_async(id: UUID) async -> User? {
        // return a User object
        do {
            
            let response  = try await supabase
                .from("users")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
            
            
            print("Raw Response:", String(data: response.data, encoding: .utf8))
            
            let user = try JSONDecoder().decode(DBUser.self, from: response.data)
            
            
            let user_profile = User(existing_user_id: user.id,
                                    existing_email : user.email,
                                    existing_phone : user.phone_number,
                                    existing_data_handler: self)
            
            return user_profile
        }
        catch{
            print("Error getting user profile from db: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    
    func get_user_profile(id: UUID)  {
        
        Task{
            do {
                if let user = try await get_user_profile_async(id : id) {
                    print("User found!")
                    print(user.get_user_id())
                } else {
                    print("User not found.")
                }
            } catch {
                print("Error getting user profile: \(error)")
            }
        }
    }
    
    func retrieve_users_trips() {
        //helper function for getting users trips? if needed
    }
    
    func update_user_vehicle(id: UUID, vehicle : Vehicle){
        
    }
    
    func update_user_profile(user: User){
        // need some thought about what these parameters look like
    }
    
    func update_username(user : User, new_username: String){
        //think of parameters here
    }
    
    func update_email(user : User, new_email : String){
        //think of parameters here
    }
    
    func get_friend_requests(user_id: UUID){
        //get all of the uuid
        //get all of the users- ask yunus
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    func create_friend_request_async(sender_id: UUID, receiver_id: UUID) async{
        do {
            
            let friend_request = FriendRequest(id: UUID(), created_at: Date(), sender : sender_id, receiver : receiver_id)
            
            try await supabase
                .from("friend_request")
                .insert(friend_request)
                .execute()
        }
        catch{
            print("Error creating friend request in db: \(error.localizedDescription)")
        }
        
    }
    
    func create_friend_request(sender_id: UUID, receiver_id: UUID){
        Task{
            await create_friend_request_async(sender_id: sender_id, receiver_id: receiver_id)
        }
    }
    
    
    func delete_friend_request_async(sender_id: UUID, receiver_id: UUID) async{
        
        do {
            
            try await supabase
                .from("friend_request")
                .delete()
                .match(["sender": sender_id, "receiver": receiver_id])
                .execute()
            
            print("Friend request successfully deleted")
        }
        catch{
            print("Error deleting friend request in db: \(error.localizedDescription)")
        }
        
    }
    
    func delete_friend_request(sender_id: UUID, receiver_id: UUID){
        
        Task{
            await delete_friend_request_async(sender_id: sender_id, receiver_id: receiver_id)
        }
        
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    func create_friendship_async(user_1_id: UUID, user_2_id: UUID) async {
        // this should call delete_friend_request at some point
        
        do {
            
            let friendship = Friendship(id: UUID(), created_at: Date(), user_1: user_1_id, user_2: user_2_id)
            
            try await supabase
                .from("friendship")
                .insert(friendship)
                .execute()
        }
        catch{
            print("Error creating friendship in db: \(error.localizedDescription)")
        }
    }
    
    func create_friendship(user_1_id: UUID, user_2_id: UUID){
        
        Task{
            await create_friendship_async(user_1_id: user_1_id, user_2_id: user_2_id)
        }
    }
    
    func delete_friendship_async(user_1_id: UUID, user_2_id: UUID) async{
        
        do {
            
            try await supabase
                .from("friendship")
                .delete()
                .match(["user_1": user_1_id, "user_2": user_2_id])
                .execute()
            
            print("Friendship successfully deleted")
        }
        catch{
            print("Error deleting friendship in db: \(error.localizedDescription)")
        }
    }
    
    func delete_friendship(user_1_id: UUID, user_2_id: UUID){
        
        Task{
            await delete_friendship_async(user_1_id: user_1_id, user_2_id: user_2_id)
        }
        
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    
    func create_vehicle_async(input_vehicle: Vehicle) async{
        
        do {
            let vehicle = DBVehicle(id: input_vehicle.get_vehicle_id(), trip_id: input_vehicle.get_session_id(), driver_id: input_vehicle.get_driver().get_user_id(), name: input_vehicle.get_name())
            
            try await supabase
                .from("vehicle")
                .insert(vehicle)
                .execute()
        }
        catch{
            print("Error creating vehicle in db: \(error.localizedDescription)")
        }
        
    }
    
    func create_vehicle(vehicle: Vehicle){
        
        Task{
            await create_vehicle_async(input_vehicle : vehicle)
        }
        
    }
    
    
    func update_vehicle_async(vehicle : Vehicle, field_to_update :String) async {
        // think about update parameters
        do{
            switch field_to_update {
            case "session_id":
                let update_value : UUID = vehicle.get_vehicle_id()
                try await supabase
                    .from("vehicle")
                    .update(["trip_id": update_value])
                    .eq("id", value: vehicle.get_vehicle_id())
                    .execute()
                print("Vehicle successfully updated")
                
            case "current_driver":
                let update_value : UUID = vehicle.get_driver().get_user_id()
                try await supabase
                    .from("vehicle")
                    .update(["driver_id": update_value])
                    .eq("id", value: vehicle.get_vehicle_id())
                    .execute()
                
                print("Vehicle successfully updated")
                
            case "name":
                let update_value : String = vehicle.get_name()
                try await supabase
                    .from("vehicle")
                    .update(["name": update_value])
                    .eq("id", value: vehicle.get_vehicle_id())
                    .execute()
                
                print("Vehicle successfully updated")
                
            default:
                print("Unsupported field update: \(field_to_update)")
                return
            }
            
        }
        catch{
            print("Error updating vehicle in db: \(error.localizedDescription)")
        }
    }
    
    func update_vehicle(vehicle : Vehicle, field_to_update :String){
        Task{
            await update_vehicle_async(vehicle : vehicle, field_to_update :field_to_update)
        }
        
    }
    
    func delete_vehicle_async(vehicle: Vehicle) async{
        
        do {
            
            try await supabase
                .from("vehicle")
                .delete()
                .eq("id", value : vehicle.get_vehicle_id())
                .execute()
            
            print("Vehicle successfully deleted")
        }
        catch{
            print("Error deleting vehicle in db: \(error.localizedDescription)")
        }
    }
    
    func delete_vehicle(vehicle: Vehicle){
        Task{
            await delete_vehicle_async(vehicle: vehicle)
        }
    }
    
    func get_vehicles(trip_id: UUID) async -> [Vehicle]? {
        
        do {
            
            let response  = try await supabase
                .from("users")
                .select()
                .eq("id", value: trip_id)
                .execute()
            
            
            print("Raw Response:", String(data: response.data, encoding: .utf8))
            
            let db_vehicles = try JSONDecoder().decode([DBVehicle].self, from: response.data)
            
            var vehicles : [Vehicle] = []
            
            for db_vehicle in db_vehicles{
                
                guard let vehicle_driver = try await get_user_profile_async(id: db_vehicle.driver_id) else {
                    print("Vehicle driver not found.")
                    return nil
                }
                guard let current_session = try await get_trip_session_async(trip_id: db_vehicle.trip_id) else {
                    print("Current session not found.")
                    return nil
                }
                
                let vehicle = Vehicle(vehicle_name: db_vehicle.name,
                                      vehicle_driver: vehicle_driver,
                                      current_session: current_session,
                                      existing_data_handler: self)
                vehicles.append(vehicle)
                
            }
            
            return vehicles
        }
        catch{
            print("Error getting user vehicles from db filtered by trip id: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    
    func create_vehicle_membership_async (rider: User, existing_vehicle : Vehicle) async {
        
        do {
            
            let vehicle = VehicleMembership(
                id : UUID(),
                vehicle_id : existing_vehicle.get_vehicle_id(),
                user_id : rider.get_user_id()
            )
            
            
            try await supabase
                .from("vehicle_membership")
                .insert(vehicle)
                .execute()
        }
        catch{
            print("Error creating vehicle membership in db: \(error.localizedDescription)")
        }
        
    }
    
    func create_vehicle_membership (rider: User, existing_vehicle : Vehicle) {
        
        Task{
            await create_vehicle_membership_async (rider: rider, existing_vehicle : existing_vehicle)
        }
    }
    
    func delete_vehicle_membership_async(rider: User, vehicle : Vehicle) async{
        
        do {
            try await supabase
                .from("vehicle_membership")
                .delete()
                .match(["vehicle_id": vehicle.get_vehicle_id(), "user_id" : rider.get_user_id()])
                .execute()
            
            print("Trip successfully deleted")
        }
        catch{
            print("Error deleting trip in db: \(error.localizedDescription)")
        }
    }
    
    func delete_vehicle_membership(rider: User, vehicle : Vehicle){
        
        Task{
            await delete_vehicle_membership_async(rider: rider, vehicle : vehicle)
        }
    }
        //----------------------------------------------------------------------------------------------------------------
        
        
        
        func create_stop_async(stop: Stop) async {
            // need to add a coordinate parameter
            do {
                
                let location_json = location_json_encoder( location : stop.get_location())
                
                let dbstop = DBStop(id: stop.get_id(), vehicle_id: stop.get_vehicle().get_vehicle_id(),
                                    location: location_json, stop_number: stop.get_number())
                
                
                try await supabase
                    .from("stop")
                    .insert(dbstop)
                    .execute()
            }
            catch{
                print("Error creating stop in db: \(error.localizedDescription)")
            }
        }
        
        func create_stop(stop : Stop){
            Task{
                await create_stop_async(stop: stop)
            }
        }
        
        func update_stop(){
            // what if people add/ takeaway stops?? how does the stop numbering happen
        }
        
        func delete_stop_async(stop: Stop) async{
            
            do {
                
                try await supabase
                    .from("stop")
                    .delete()
                    .match(["id": stop.get_id()])
                    .execute()
                
                print("Stop successfully deleted")
            }
            catch{
                print("Error deleting stop in db: \(error.localizedDescription)")
            }
            
        }
        
        func delete_stop(stop: Stop){
            
            Task {
                await delete_stop_async(stop: stop)
            }
        }
        
        func get_vehicle_stops_async(vehicle: Vehicle) async -> [Stop]?{
            
            do {
                let response  = try await supabase
                    .from("stop")
                    .select()
                    .eq("vehicle_id", value: vehicle.get_vehicle_id())
                    .single()
                    .execute()
                
                let dbstops = try JSONDecoder().decode([DBStop].self, from: response.data)
                
                var stops : [Stop] = []
                for dbstop in dbstops{
                    stops.append(Stop(new_location: location_json_decoder(json: dbstop.location),
                                      stop_number: dbstop.stop_number,
                                      vehicle: vehicle,
                                      data_handler: self))
                }
                return stops
                // Test and finish this!!!!!!
                
            }
            catch{
                print("Error getting vehicle stops from db: \(error.localizedDescription)")
                return nil
            }
        }
        
        func get_vehicle_stops(vehicle: Vehicle) {
            
            
        }
        
        
        //----------------------------------------------------------------------------------------------------------------
        
        func location_json_encoder(location : (latitude: Double, longitude: Double)) -> String{
            
            let db_location = Location(latitude: location.latitude, longitude: location.longitude)
            
            if let json_data = try? JSONEncoder().encode(db_location),
               let json_string = String(data: json_data, encoding: .utf8) {
                print("JSON STRING-", json_string)
                return json_string
            }
            else{
                print("Unable to convert location to json")
                return "error"
            }
        }
        
        func location_json_decoder(json : String) -> (latitude: Double, longitude: Double){
            
            guard let json_data = json.data(using: .utf8) else {
                print("Unable to extract data from string")
                return (0.0,0.0) }
            
            do {
                let decoded_location = try JSONDecoder().decode(Location.self, from: json_data)
                return (decoded_location.latitude, decoded_location.longitude)
            } catch {
                print("Error decoding JSON: \(error)")
                return (0.0,0.0)
            }
        }
        
        
        
        func create_trip_session_async(trip_session: TripSession) async{
            
            do {
                
                let start_location_json = location_json_encoder( location : trip_session.get_start_location())
                let end_location_json = location_json_encoder( location : trip_session.get_end_location())
                
                let trip = Trip(id: trip_session.get_session_id(),
                                start_time: trip_session.get_start_time(),
                                end_time: trip_session.get_end_time(),
                                start_location: start_location_json,
                                end_location: end_location_json,
                                trip_leader: trip_session.get_trip_leader().get_user_id(),
                                completed: trip_session.get_completed(),
                                name: trip_session.get_name(),
                                session_code: trip_session.get_session_code())
                
                try await supabase
                    .from("trip")
                    .insert(trip)
                    .execute()
            }
            catch{
                print("Error creating trip session in db: \(error.localizedDescription)")
            }
            
        }
        
        func create_trip_session(trip_session: TripSession){
            Task {
                await create_trip_session_async(trip_session: trip_session)
            }
        }
        
        func get_trip_session_async(trip_id : UUID ) async -> TripSession? {
            
            do {
                
                let response  = try await supabase
                    .from("trip")
                    .select()
                    .eq("id", value: trip_id)
                    .single()
                    .execute()
                
                print("Raw Response:", String(data: response.data, encoding: .utf8))
                let trip = try JSONDecoder().decode(TripOutput.self, from: response.data)
                
                //we need to get the trip leader's user profile
                guard let trip_leader = try await get_user_profile_async(id: trip.trip_leader) else {
                    print("Trip leader not found.")
                    return nil
                }
                
                print("Trip leader found:", trip_leader.get_user_id())
                
                // we need to get all of the vehicles in the trip
                
                guard let vehicles = try await get_vehicles(trip_id: trip.id) else {
                    print("Unable to find vehicles for the trip")
                    return nil
                }
                
                print("Vehicles found")
                
                let formatter = ISO8601DateFormatter()
                
                guard let start_time = formatter.date(from: trip.start_time) else {
                    print("Invalid date format")
                    return nil
                }
                
                guard let end_time = formatter.date(from: trip.end_time) else{
                    print("Invalid date format")
                    return nil
                }
                
                let trip_session = TripSession(existing_trip_name: trip.name,
                                               existing_session_id: trip.id,
                                               //existing_notifications: trip.notifications,
                                               
                                               //get the vehicles filtered by the trip_id
                                               existing_vehicles: vehicles,
                                               existing_trip_leader: trip_leader,
                                               
                                               existing_session_code: trip.session_code,
                                               existing_start_location: location_json_decoder(json: trip.start_location),
                                               existing_end_location: location_json_decoder(json: trip.end_location),
                                               existing_start_time: start_time,
                                               existing_end_time: end_time,
                                               existing_data_handler: self)
                return trip_session
            }
            catch{
                
                print("Error getting trip session from db: \(error.localizedDescription)")
                return nil
            }
            
        }
        
        func get_trip_session(trip_id: UUID) {
            
            Task{
                do {
                    if let trip_session = try await get_trip_session_async(trip_id : trip_id) {
                        print("Trip Session found!")
                        print(trip_session.get_session_id())
                        
                    } else {
                        print("Trip Session not found.")
                        
                    }
                } catch {
                    print("Error getting Trip Session: \(error)")
                    
                }
            }
        }
        
        
        func update_trip_session_async(trip_session: TripSession, field_to_update : String) async{
            // need to think about the update standards
            //should we have to know what the column in the table is called to use this method?
            do{
                switch field_to_update {
                case "completed":
                    let update_value : Bool = trip_session.get_completed()
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                case "name":
                    let update_value : String = trip_session.get_name()
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                case "start_time":
                    let update_value : Date = trip_session.get_start_time()
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                case "end_time":
                    let update_value : Date = trip_session.get_end_time()
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                case "start_location":
                    let update_value : String = location_json_encoder( location : trip_session.get_start_location())
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                    
                case "end_location":
                    let update_value : String = location_json_encoder( location : trip_session.get_end_location())
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                case "trip_leader":
                    let update_value : UUID = trip_session.get_trip_leader().get_user_id()
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                case "session_code":
                    let update_value : String  = trip_session.get_session_code()
                    try await supabase
                        .from("trip")
                        .update([field_to_update: update_value])
                        .eq("id", value: trip_session.get_session_id())
                        .execute()
                    
                    print("Trip session successfully updated")
                    
                default:
                    print("Unsupported field update for update trip session: \(field_to_update)")
                    return
                }
            }
            catch{
                print("Error updating trip in db: \(error.localizedDescription)")
            }
        }
        
    
        func get_trip_session_async(session_code : String ) async -> TripSession? {
        
            do {
            
                let response  = try await supabase
                    .from("trip")
                    .select()
                    .eq("session_code", value: session_code)
                    .single()
                    .execute()
            
                print("Raw Response:", String(data: response.data, encoding: .utf8))
                let trip = try JSONDecoder().decode(TripOutput.self, from: response.data)
            
                //we need to get the trip leader's user profile
                guard let trip_leader = try await get_user_profile_async(id: trip.trip_leader) else {
                    print("Trip leader not found.")
                    return nil
                }
            
                print("Trip leader found:", trip_leader.get_user_id())
            
                // we need to get all of the vehicles in the trip
            
                guard let vehicles = try await get_vehicles(trip_id: trip.id) else {
                    print("Unable to find vehicles for the trip")
                    return nil
                }
            
                print("Vehicles found")
            
                let formatter = ISO8601DateFormatter()
            
                guard let start_time = formatter.date(from: trip.start_time) else {
                    print("Invalid date format")
                    return nil
                }
            
                guard let end_time = formatter.date(from: trip.end_time) else{
                    print("Invalid date format")
                    return nil
                }
            
                let trip_session = TripSession(existing_trip_name: trip.name,
                                           existing_session_id: trip.id,
                                           //existing_notifications: trip.notifications,
                                           
                                           //get the vehicles filtered by the trip_id
                                           existing_vehicles: vehicles,
                                           existing_trip_leader: trip_leader,
                                           
                                           existing_session_code: trip.session_code,
                                           existing_start_location: location_json_decoder(json: trip.start_location),
                                           existing_end_location: location_json_decoder(json: trip.end_location),
                                           existing_start_time: start_time,
                                           existing_end_time: end_time,
                                           existing_data_handler: self)
                return trip_session
            }
            catch{
            
                print("Error getting trip session from db: \(error.localizedDescription)")
                return nil
            }
        
    }
        

    
    
        func update_trip_session(trip_session: TripSession, field_to_update : String){
            Task{
                await update_trip_session_async(trip_session: trip_session, field_to_update : field_to_update)
            }
        }
        
        func delete_trip_session_async(trip_session: TripSession) async{
            //what happens when we delete a trip?
            do {
                
                try await supabase
                    .from("trip")
                    .delete()
                    .match(["id": trip_session.get_session_id()])
                    .execute()
                
                print("Trip successfully deleted")
            }
            catch{
                print("Error deleting trip in db: \(error.localizedDescription)")
            }
        }
        
        func delete_trip_session(trip_session: TripSession){
            Task{
                await delete_trip_session_async(trip_session: trip_session)
            }
        }
    }
