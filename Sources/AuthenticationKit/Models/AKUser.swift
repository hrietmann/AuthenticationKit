//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation





public protocol AKUser: Identifiable {
    
    var id: ID { get }
    var username: String? { get }
    var email: String? { get }
    var emailVerified: Bool { get }
    var profileImageURL: URL? { get }
    
}
