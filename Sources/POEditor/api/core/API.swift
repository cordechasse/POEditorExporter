//
// Created by Nicolas Bush on 17/06/2022.
//

import Foundation

public struct API {
	
	/**
	 Décodeur des données JSON
	 */
	public static let jsonDecoder : JSONDecoder = {
		let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()
	
	
	/**
	 Encodeur des données JSON
	 */
	public static let jsonEncoder : JSONEncoder = {
		let decoder = JSONEncoder()
		decoder.dateEncodingStrategy = .iso8601
		decoder.keyEncodingStrategy = .convertToSnakeCase
		return decoder
	}()
	
	
    
    /// Fetch les données JSON sur le serveur en asynchrone
    /// - Parameter urlRequest : La requete
    /// - Returns : l'objet T
    static func fetch<T: Decodable>(urlRequest : URLRequest) async throws -> T {
        let rawData = try await fetchRawData(urlRequest: urlRequest)
        return try rawData.decoded(decoder: jsonDecoder)
    }
        
    
    /// Fetch les données brutes sur le serveur en asynchrone
    /// - Parameter services : le service
    /// - Returns : des Data
    static func fetchRawData(urlRequest : URLRequest) async throws -> Data {
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        guard let rawStatusCode = (urlResponse as? HTTPURLResponse)?.statusCode,
              let statusCode = HTTPStatusCode(rawValue: rawStatusCode)else {
            let genericError = APIError.expectationFailed(description: "no StatusCode")
            throw genericError
        }
        
        
        //on traite le statusCode
        switch rawStatusCode {
            case 200..<300:
                return data
            default:
 
                let error = APIError.serverError(
                    urlRequest: urlRequest,
                    statusCode:  statusCode,
                    rawResponse: data
                )

                throw error
        }
    }
    
    
    /// Download des datas depuis le serveur en asynchrone
    /// - Parameter services : le service
    /// - Returns : l'URL ou est stocké le fichier temporaire
    static func download(urlRequest : URLRequest) async throws -> URL {
        let (url, urlResponse) = try await URLSession.shared.download(for: urlRequest)
        
        guard let rawStatusCode = (urlResponse as? HTTPURLResponse)?.statusCode,
              let statusCode = HTTPStatusCode(rawValue: rawStatusCode)else {
            let error = APIError.expectationFailed(description: "no StatusCode")
            throw error
        }
        
        
        //on traite le statusCode
        switch rawStatusCode {
            case 200..<300:
                return url
            default:
                
                let error = APIError.serverError(
                    urlRequest: urlRequest,
                    statusCode:  statusCode,
                    rawResponse: nil
                )

                throw error
        }
    }
    
    
    
    
    // Envoi les données sur le serveur sans lire le resultat retourné
    static func send(urlRequest : URLRequest) async throws {
        _ = try await fetchRawData(urlRequest: urlRequest)
    }
    
    
    
    
    
    
    

	 
}
