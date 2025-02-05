//
//  first_controller.swift
//  FirstWebApp
//
//  Created by Tanner Flagg on 1/29/25.
//
import Vapor

struct first_controller: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("first") { group in
            group.get("hello", ":username") { request -> String in
                return "first!"
            }
        }
    }
    
}
