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
    
    init(error: CairoError) {
        self.init(rawValue: error.rawValue)
    }
}

public extension Cairo.Status {
    
    static var success: Cairo.Status { CAIRO_STATUS_SUCCESS }
}

internal extension Cairo.Status {
    
    func throwsError() throws(CairoError) {
        guard let error = CairoError(self) else {
            return
        }
        throw error
    }
}

extension Cairo.Status: @retroactive CustomStringConvertible {
    
    public var description: String {
        let cString = cairo_status_to_string(self)!
        let string = String(cString: cString)
        return string
    }
}

