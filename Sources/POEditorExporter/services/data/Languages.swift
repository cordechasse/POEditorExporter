//
//  File.swift
//  
//
//  Created by Nicolas Bush on 26/05/2020.
//

import Foundation

struct Languages {
	var languages : [Language]
}

extension Languages : Codable { }


struct Language  {
	var name : String
	var code : String
}

extension Language : Codable { }




