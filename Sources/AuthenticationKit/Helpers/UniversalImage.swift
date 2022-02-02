//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



#if os(iOS) || os(tvOS)
import UIKit
public typealias UniversalImage = UIImage

public extension UniversalImage {
    func resized(to target: CGSize) -> UniversalImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}
#endif

#if os(macOS)
import AppKit
public typealias UniversalImage = NSImage
#endif
