//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation



public enum AKState<User: AKUser> {
    
    
    case loading
    case connected(user: User)
    case disconnected
    
    
    public var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }
    
    
    public var isConnected: Bool {
        switch self {
        case .connected: return true
        default: return false
        }
    }
    
    
    public var isDisconnected: Bool {
        switch self {
        case .disconnected: return true
        default: return false
        }
    }
    
    public var user: User? {
        switch self {
        case .connected(let user): return user
        default: return nil
        }
    }
    
    
}
