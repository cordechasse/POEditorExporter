//
// Created by Nicolas Bush on 17/11/2021.
// Copyright (c) 2021 Nicolas Bush. All rights reserved.
//

import Foundation

public protocol Service {
	
	var method : HTTPMethod { get }
	var path : String { get }
	var body : ServiceBody? { get }
	var queryParameters : QueryParameters? { get }
	
	func asURLRequest() throws -> URLRequest
    
}


extension Service {
	
	/**
	 Retourne l'URLRequest du service à partir de ses paramètres internes
	 - Returns: un URLRequest
	 */
    public func asURLRequest() throws -> URLRequest {
		switch body {
			case .none:
				return try _getURLRequest(path: path,
                                          method: method,
                                          queryParameters: queryParameters)
                
			case .data(let data, let contentType):
				return try _getURLRequest(path: path,
                                          method: method,
                                          queryParameters: queryParameters,
                                          data: data,
                                          contentType: contentType)
                
			case .json(let encodable):
				let data = try encodable.encoded()
				return try _getURLRequest(path: path,
                                          method: method,
                                          queryParameters: queryParameters,
                                          data: data,
                                          contentType: "application/json")
                
			case .multipartFormData(let values):
				return try _getURLRequest(path: path,
                                          method: method,
                                          queryParameters: queryParameters,
                                          multipartFormData: values)
            case .formData(let values):
                return try _getURLRequest(path: path,
                                          method: method,
                                          queryParameters: queryParameters,
                                          formData: values)
		}
	}
	
	
	/**
	 Retourne l'URLRequest à partir du path, de la méthode et des paramètres
	 - Parameters:
	   - api: l'API a à utiliser
	   - path: le path
	   - method: la méthode HTTP
	   - queryParameters: le dictionnaire de paramètres
	 - Returns: un URLRequest
	 */
	private func _getURLRequest(path : String,
								method : HTTPMethod,
								queryParameters : QueryParameters?) throws -> URLRequest {
		var urlRequest : URLRequest
		
		// on construit l'URL avec ses components
		var components = URLComponents(string: path)
		
		//on ajoute les queryItems
		components?.queryItems = queryParameters?.queryItems
		
		// on encode le queryItems afin d'encoder le "+"
		let characterSet = CharacterSet(charactersIn: "/+").inverted
		let percentEncodedQuery = components?.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: characterSet)
		components?.percentEncodedQuery = percentEncodedQuery
		
		// on recupere l'URL
		guard let url = components?.url else {
			throw APIError.URLGenerationFailure
		}
		
		urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method.rawValue
		
		// on informe le serveur qu'on veut du JSON en retour (pas de redirection)
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		
		
		return urlRequest
	}
	
	
	/**
	 Retourne l'URLRequest à partir du path, de la méthode, des datas et contentType
	 - Parameters:
	   - api: l'API a à utiliser
	   - path: le path
	   - method: la méthode HTTP
	   - data: les données au format binaire
	   - contentType: le contentType
	 - Returns: un URLRequest
	 */
	private func _getURLRequest(path : String,
								method : HTTPMethod,
								queryParameters : QueryParameters?,
								data : Data,
								contentType : String) throws -> URLRequest {
		var urlRequest = try _getURLRequest(path: path, method: method, queryParameters: queryParameters)
		urlRequest.httpBody = data
		urlRequest.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
		urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
		return urlRequest
	}
	
	
	/**
	 Retourne l'URLRequest à partir du path, de la méthode, des datas et du multipartFormData
	 - Parameters:
	   - api: l'API a à utiliser
	   - path: le path
	   - method: la méthode HTTP
	   - body: les données au format binaire
	   - multipartFormData: les données MultipartFormData
	 - Returns: un URLRequest
	 */
	private func _getURLRequest(path : String,
								method : HTTPMethod,
								queryParameters : QueryParameters?,
								multipartFormData : [MultipartFormDataObject]) throws -> URLRequest {
		var urlRequest = try _getURLRequest(path: path, method: method, queryParameters: queryParameters)
		
		let boundary : String = UUID().uuidString
		
		let httpBody = NSMutableData()
		multipartFormData.forEach { value in
			httpBody.append(value.getField(boundary: boundary))
		}
		
		urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		httpBody.append("--\(boundary)--")
		urlRequest.httpBody = httpBody as Data
		
		return urlRequest
	}
	
    
    /// Retourne l'URLRequest à partir du path, de la méthode, des datas et duformData
    ///     - Parameters:
    ///       - path: le path
    ///       - method: la méthode HTTP
    ///       - queryParameters: Les parametres en Query
    ///       - formData: les données FormData
    ///       - queryParameters:
    ///     - Returns: un URLRequest
    /// - Throws:
    private func _getURLRequest(path : String, method : HTTPMethod, queryParameters : QueryParameters?, formData : [URLQueryItem]) throws -> URLRequest {
        var urlRequest = try _getURLRequest(path: path, method: method, queryParameters: queryParameters)
        
        var comps = URLComponents()
        comps.queryItems = formData
        
        if let encodedQueries = comps.percentEncodedQuery {
            urlRequest.httpBody = encodedQueries.data(using: .utf8)
        }
        
        return urlRequest
    }
    
	
	/**
	 Le path qui sera affiché dans les logs
	 */
	var debugPath : String {
		let queryString : String
		
		if let queryItems = queryParameters?.queryItems,
		   !queryItems.isEmpty {
			
			queryString = "?\(queryItems.map { "\($0.name)=\($0.value ?? "")"}.joined(separator: "&"))"
		}
		else {
			queryString = ""
		}
		
        return "\(method.rawValue.uppercased()) \(path)\(queryString)"
	}
	
	
	
	
	//---------------------------
	//			HELPERS
	//---------------------------
    
    /// Fetch les données sur le serveur en asynchrone
    /// - Returns : l'objet demandé
    public func fetch<T: Decodable>() async throws -> T {
        let urlRequest = try asURLRequest()
        return try await API.fetch(urlRequest: urlRequest)
    }
    
    
    /// Envoie les données sur le serveur en asynchrone
    public func send() async throws {
        let urlRequest = try asURLRequest()
        try await API.send(urlRequest: urlRequest)
    }
    
    
    /// Télécharge les données sur le serveur en asynchrone
    public func download(to targetURL: URL) async throws {
        let urlRequest = try asURLRequest()
        
        //on verifie que le fichier de destination n'existe pas
        guard !FileManager.default.fileExists(atPath: targetURL.path) else {
            throw APIError.downloadFailure(description: "A file already exist at target destination")
        }
        
        //on télécharge le fichier
        let tempURL = try await API.download(urlRequest: urlRequest)
        
        //on le copie à destination
        try FileManager.default.moveItem(at: tempURL, to: targetURL)
    }
    
    
    
	
}





