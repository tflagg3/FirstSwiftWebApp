//
//  File.swift
//  FirstWebApp
//
//  Created by Tanner Flagg on 2/4/25.
//

//import Foundation
//
//class CacheEngine {
//    
//    private let trip_cache = NSCache<NSString, TripSession>()
//    private var data_handler: DataHandler
//    
//    init(datahandler: DataHandler){
//       self.data_handler = datahandler
//    }
//    
//    func save_trip(trip: TripSession) {
//        self.trip_cache.setObject(trip, forKey: NSString(string: trip.get_session_code()))
//    }
//    
//    func get_trip(join_code: String) -> TripSession{
//        if let trip = trip_cache.object(forKey: NSString(string: join_code)) {
//            return trip
//        }
//        Task {
//            let null_trip = await data_handler.get_trip_session_async(trip_id: UUID("dc8dbed5-22b3-495d-ab8d-2c6684fb2dd4")!)
//            return null_trip
//        }
//        // need to return a trip somehow...
//        let null_trip = TripSession(
//            start: (0.0, 0.0),
//            end: (0.0, 0.0),
//            set_trip_leader: User(
//                
//            )
//        )
//    }
//    
//    
//}
