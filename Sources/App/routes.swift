import Vapor

func routes(_ app: Application) throws {
    
    let datahandler = DataHandler()
    let decoder = JSONDecoder()
    // let cache = CacheEngine(datahandler: datahandler)
    
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, Tanner!"
    }
    
    app.get("caravan") { req async -> String in
        "Welcome to Caravan!"
    }
    
    
    
    
    /* TODO */
    
    
    
    let update_location = app.grouped("update_location")
    update_location.post { req in
        if let body = req.body.data {
            do {
                let location_params = try decoder.decode(UpdateLocationAPI.self, from: body)
                // need tp implement DB last_locations
            }
        }
        return "To be implemented"
    }
    
    app.get("get_stops", ":vehicle_id") { req async -> String in
        let vehicle_id = req.parameters.get("vehicle_id")
        return "to be implemented"
    }
    
    
    
    
    
    
    
    app.get("join_trip", ":code") {req async -> String in
        let code = req.parameters.get("code")
        let ip = req.remoteAddress!.description
        let cache = req.application.cache
        do {
            try await cache.set("User", to: ip, expiresIn: .days(1))
        } catch {
            return "Error caching the IP"
        }
        guard let trip = await datahandler.get_trip_session_async(session_code: code!) else {
            return "could not find the trip"
        }
        
        return "code: \(trip.get_session_code()) joined by \(ip)"
    }
    
    app.get("get_user_cache") { req async -> String in
        let cache = req.application.cache
        do {
            if let cachedData: String = try await cache.get("User") {
                return "data: \(cachedData)"
            }
        } catch {
            return "error retrieving cache"
        }
        return "could not retrieve cache"
    }
    

    let start_trip_session = app.grouped("start_trip_session")
    start_trip_session.post { req in
        if let body = req.body.data {
            do {
                let trip_params = try decoder.decode(StartTripAPI.self, from: body)
                guard let trip_leader = await datahandler.get_user_profile_async(id: trip_params.trip_leader_ID) else {
                    return "Could not find the trip leader account"
                }
        
                let new_trip = TripSession(
                    start: (latitude: Double(trip_params.start_lat)!, longitude: Double(trip_params.start_long)!),
                    destination: (latitude: Double(trip_params.dest_lat)!, longitude: Double(trip_params.dest_long)!),
                    set_trip_leader: trip_leader,
                    set_trip_name: trip_params.trip_name,
                    proposed_start_time: Date(),
                    proposed_end_time: Date(), // need logic to take a date input from the JSON
                    existing_data_handler: datahandler
                )
                
                
                // create in DB
                new_trip.create_trip_session_in_db()
                
                return "created a trip with code \(new_trip.get_session_code())"
            }
        }
        return "failed to decode JSON"
    }
    
    
    
    
    let friend_requests = app.grouped("friend_request")
    
    friend_requests.post { req in
        
        if let body = req.body.data {
            let decoder = JSONDecoder()
            do {
                let friend_request = try decoder.decode(FriendRequestAPI.self, from: body)
                // DataHandler().create_friend_request(sender_id: friend_request.sender_id, receiver_id: friend_request.receiver_id)
                return "received friend request from \(friend_request.sender_id) to \(friend_request.receiver_id)"
            } catch {
                return "failed to decode JSON \(error)"
            }
        }
        return "failed to decode JSON"
    }
    
    
    
}

