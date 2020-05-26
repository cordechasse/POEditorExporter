//
//  File.swift
//  
//
//  Created by Nicolas Bush on 26/05/2020.
//

import Foundation

struct Export : Codable {
	var url : String
	
	enum CodingKeys: String, CodingKey {
        case url
	}
	
}
