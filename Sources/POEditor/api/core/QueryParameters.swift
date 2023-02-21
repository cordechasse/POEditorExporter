//
// Created by Nicolas Bush on 22/06/2022.
// Copyright (c) 2022 OpenRunner. All rights reserved.
//

import Foundation

public struct QueryParameters {
	
	private(set) var queryItems = [URLQueryItem]()
	
    public init(){}
    
    
	public mutating func add(name : String, value : Any) {
		queryItems.append(URLQueryItem(name: name, value: String(describing: value)))
	}
	
	public mutating func add(name : String, value : [Any]) {
		value.forEach { object in
			queryItems.append(URLQueryItem(name: "\(name)[]", value: String(describing: object)))
		}
	}
	
	public mutating func merge(with other: QueryParameters) {
		queryItems.append(contentsOf: other.queryItems)
	}
}
