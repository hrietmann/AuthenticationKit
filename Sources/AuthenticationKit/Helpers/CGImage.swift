//
//  File.swift
//  
//
//  Created by Hans Rietmann on 28/01/2022.
//

import Foundation
import SwiftUI



extension CGImage {
    
    public func png(named fileName: String) -> Data? {
        let trimmedName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "\(trimmedName).png" as CFString, 1, nil)
        else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
    
}
