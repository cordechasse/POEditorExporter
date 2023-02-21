//
//  Created by Nicolas Bush on 19/02/2023.
//

import Foundation

class POEditorAPIHandler {
    
    private let poEditorConfiguration : POEditorConfiguration
    
    /// Constructor
    /// - Parameters:
    ///   - token: the readonly token
    ///   - projectId: the project id
    init(token : String, projectId : String) {
        poEditorConfiguration = POEditorConfiguration(apiPath: "https://api.poeditor.com/v2", apiToken: token, projectId: projectId)
    }
    
}


extension POEditorAPIHandler : LanguagesFetcher {
    
    /// Fetch the available languages asynchronisly
    /// - Returns: List of available languages
    func getLanguages() async throws -> [Language] {
        
        let request = POEditorService.getLanguages(configuration: poEditorConfiguration)
        let response : POEditorResponse<Languages> = try await request.fetch()
        return response.result.languages
    }
    
    
    
    /// Fetch the translation file URL
    /// - Parameters:
    ///   - language: the language
    ///   - type: the type of export
    /// - Returns: the file URL (available 10 min)
    func getTranslationFileURL(language : String, type : ExportProjectType) async throws -> URL {
        let request = POEditorService.export(configuration: poEditorConfiguration,
                                             language: language,
                                             type: type)
        let response : POEditorResponse<ExportProjectResult> = try await request.fetch()
        return response.result.url
    }
    
    
}
