//
//  QuickLook.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/3/19.
//

#if os(macOS)
import Foundation
import AppKit

public extension Surface {
    
    @objc(debugQuickLookObject)
    var debugQuickLookObject: AnyObject {
        
        let filePath = NSTemporaryDirectory() + "CairoSwiftQuickLook\(UUID().uuidString).png"
        self.writePNG(atPath: filePath)
        let image = NSImage(byReferencingFile: filePath)!
        return image
    }
}

public extension Context {
    
    @objc(debugQuickLookObject)
    var debugQuickLookObject: AnyObject {
        return surface.debugQuickLookObject
    }
}
#endif
