//
//  File.swift
//  
//
//  Created by Nicolas Bush on 26/05/2020.
//

import Foundation

enum API {
	
	case getLanguages
	case exportLanguage(code : String)
	case getTranslations(url : String)
	
	
	
	
	
	var path : String {
		switch self {
			case .getLanguages:
				return "/languages/list"
			case .exportLanguage:
				return "/projects/export"
			case .getTranslations(let url):
				return url
		}
	}
	
	
	var method : String {
		switch self {
			case .getLanguages:
				return "POST"
			case .exportLanguage:
				return "POST"
			case .getTranslations:
				return "GET"
		}
	}
	
	
	var parameters : [String: Any] {
		switch self {
			case .getLanguages:
				return [:]
			case .exportLanguage(let code):
				return ["language": code, "type": "apple_strings"]
			case .getTranslations:
				return [:]
		}
	}
	
	func getURLRequest(api: String, token: String, projectId: String) -> URLRequest? {
		
		let fullPath = path.starts(with: "http") ? path : api + path
		
		guard let url = URL(string: fullPath) else {
			return nil
		}
		
		
		
		var request = URLRequest(url: url)
		request.httpMethod = method
		
		var postString = "api_token=\(token)&id=\(projectId)"
		parameters.forEach {
			postString += "&\($0.key)=\($0.value)"
		}
		
		request.httpBody = postString.data(using: .utf8)
		
		return request
	}

	
	
	
	
}
