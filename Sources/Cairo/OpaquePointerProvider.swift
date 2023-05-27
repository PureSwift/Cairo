//
//  OpaquePointerProvider.swift
//  Cairo
//
//  Created by Rayman Rosevear on 2023/05/16.
//  Copyright © 2023 PureSwift. All rights reserved.
//

/// This file adds methods providing some extensibility to the library, giving access to the `OpaquePointer`s to the
/// underlying Cairo opaque struct pointers.

public protocol OpaquePointerProvider {

    /// Calls the given closure with the underlying `OpaquePointer`.
    ///
    /// The pointer passed as an argument to `body` is valid only during the execution of `withUnsafeOpaquePointer(_:)`.
    /// Do not store or return the pointer for later use.
    ///
    /// - Parameters:
    ///   - body: A closure with an opaque pointer parameter. If `body` has a return value, that value is also used as
    ///     the return value for the `withUnsafeOpaquePointer(_:)` method. The pointer argument is valid only for the
    ///     duration of the method's execution.
    /// - Returns: The return value, if any, of the `body` closure parameter.
    func withUnsafeOpaquePointer<Result>(_ body: (OpaquePointer) throws -> Result) rethrows -> Result
}

/// Internally conform to this protocol to automatically become an `OpaquePointerProvider`.
internal protocol OpaquePointerOwner: OpaquePointerProvider {
    var internalPointer: OpaquePointer { get }
}

extension OpaquePointerOwner {
    public func withUnsafeOpaquePointer<Result>(_ body: (OpaquePointer) throws -> Result) rethrows -> Result {
        try body(self.internalPointer)
    }
}
