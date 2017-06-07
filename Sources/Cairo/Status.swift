//
//  Status.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/8/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public typealias Status = cairo_status_t

public extension Cairo.Status {
    
    func toError() -> CairoError? {
        
        return CairoError(rawValue: rawValue)
    }
}

extension Cairo.Status: CustomStringConvertible {
    
    public var description: String {
        
        let cString = cairo_status_to_string(self)!
        
        let string = String(cString: cString)
        
        return string
    }
}

public struct CairoError: RawRepresentable, CustomStringConvertible, Error {
    
    public typealias RawValue = cairo_status_t.RawValue
    
    public let rawValue: RawValue
    
    public init?(rawValue: RawValue) {
        
        guard rawValue > 0 && rawValue < CAIRO_STATUS_LAST_STATUS.rawValue
            else { return nil }
        
        self.rawValue = rawValue
    }
    
    public var description: String {
        
        return Cairo.Status(rawValue: self.rawValue).description
    }
}
