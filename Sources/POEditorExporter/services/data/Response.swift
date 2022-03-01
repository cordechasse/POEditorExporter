//
//  File.swift
//  
//
//  Created by Nicolas Bush on 26/05/2020.
//

import Foundation


struct Response<T : Codable> : Codable {
	var response : ResponseResult
	var result : T?
	
	enum CodingKeys: String, CodingKey {
        case response
		case result
    }
	
}


struct ResponseResult {
	var status : String
	var code : String
	var message : String
}

extension ResponseResult : Codable { }

