//
// Created by Nicolas Bush on 05/11/2021.
// Copyright (c) 2021 Nicolas Bush. All rights reserved.
//

import Foundation

extension Encodable {
	
	/**
	 Retourne la donnée au format JSON
	 - Parameters:
	   - encoder: le JSONEncoder à utiliser
	 - Returns: un JSON au format string
	 */
	func toJsonString(encoder : JSONEncoder = API.jsonEncoder) throws -> String {
		let data = try encoded(encoder: encoder)
		return String(data: data, encoding: .utf8)!
	}
	
	/**
	 Retourne la donnée au format JSON
	 - Parameters:
	   - encoder: le JSONEncoder à utiliser
	 - Returns: un JSON au format string
	 */
	func encoded(encoder : JSONEncoder = API.jsonEncoder) throws -> Data {
		try encoder.encode(self)
	}
	
	
	/**
	 Sauvegarde dans un fichier local
	 - Parameters:
	   - url: l'URL de destination
	   - encoder: le JSONEncoder à utiliser
	 */
	func save(to url : URL, encoder : JSONEncoder = API.jsonEncoder) throws {
		//on encode le JSON
		let data = try encoded(encoder: encoder)
		
		//on enregistre le fichier
		try data.write(to: url, options: .atomic)
	}
	
}


extension Data {
	
	/**
	 Retourne l'objet decodé
	 - Parameters:
 		- decoder: le decoder à utiliser
	 - Returns: l'objet
	 @Throws: une éventuelle erreur en cas de decodage
	 */
	func decoded<T: Decodable>(decoder : JSONDecoder = API.jsonDecoder) throws -> T {
		try decoder.decode(T.self, from: self)
	}
}


extension Decodable {
	
	/**
     Construit l'objet à partir de sa representation JSON String
     - Parameters:
         - json: le JSON au format String
     */
	init(json : String, decoder : JSONDecoder = API.jsonDecoder) throws {
		guard let data = json.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "can't convert String to Data"))
		}
		
		try self.init(json: data, decoder: decoder)
	}
	
	/**
     Construit l'objet à partir de sa representation JSON Data
     - Parameters:
         - json: le JSON au format Data
     */
	init(json : Data, decoder : JSONDecoder = API.jsonDecoder) throws {
		self = try decoder.decode(Self.self, from: json)
	}
	
	
	/**
     Construit l'objet à partir d'une URL
     - Parameters:
        - from: l'URL locale du fichier
	 	- decoder: le decoder JSON à utiliser
     */
	init(from url : URL, decoder : JSONDecoder = API.jsonDecoder) throws {
		let data = try Data(contentsOf: url)
		self = try data.decoded(decoder: decoder)
	}
	
	
}

