//
//  File.swift
//  
//
//  Created by Hans Rietmann on 31/01/2022.
//

import Foundation
import Combine



@MainActor
public class AuthenticationSession: ObservableObject {
    
    public var completion: (() -> ())?
    
    public init() {
        
    }
    
}
