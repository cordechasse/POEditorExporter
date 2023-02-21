//
//  Created by Nicolas Bush on 19/02/2023.
//

import Foundation

enum POEditorService : Service {
    
    case getLanguages(configuration : POEditorConfiguration)
    case export(configuration : POEditorConfiguration, language : String, type: ExportProjectType)
    
    var method: HTTPMethod {
        switch self {
            case .getLanguages:
                return .post
            case .export:
                return .post
        }
    }
    
    
    var path: String {
        switch self {
            case .getLanguages(let configuration):
                return "\(configuration.apiPath)/languages/list"
            case .export(let configuration, _, _):
                return "\(configuration.apiPath)/projects/export"
        }
    }
    
    
    var body: ServiceBody?  {
        switch self {
            case .getLanguages(let configuration):
                return .formData(
                    values: [
                        URLQueryItem(name: "api_token", value: configuration.apiToken),
                        URLQueryItem(name: "id", value: configuration.projectId),
                    ]
                )
            case .export(let configuration, let language, let type):
                return .formData(
                    values: [
                        URLQueryItem(name: "api_token", value: configuration.apiToken),
                        URLQueryItem(name: "id", value: configuration.projectId),
                        URLQueryItem(name: "language", value: language),
                        URLQueryItem(name: "type", value: type.rawValue),
                    ]
                )
                
                
        }
    }
    
    
    var queryParameters: QueryParameters? {
        nil
    }
    
    
}

