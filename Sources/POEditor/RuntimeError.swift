//
//  File.swift
//  
//
//  Created by Nicolas Bush on 24/06/2020.
//

import Darwin
import Foundation


public struct RuntimeError: Error, CustomStringConvertible {
    
    public var description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
