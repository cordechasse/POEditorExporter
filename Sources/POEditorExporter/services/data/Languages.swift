//
//  File.swift
//  
//
//  Created by Nicolas Bush on 26/05/2020.
//

import Foundation

struct Languages : Codable {
	var languages : [Language]
	
	enum CodingKeys: String, CodingKey {
        case languages
    }
	
}


struct Language : Codable {
	var name : String
	var code : String
	
	enum CodingKeys: String, CodingKey {
        case name
		case code
    }
}




