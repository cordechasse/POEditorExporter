//
//  Created by Nicolas Bush on 19/02/2023.
//

import Foundation
import ArgumentParser
import Path
import Progress

public struct FetchTranslationsCommand: AsyncParsableCommand {
    
    @Option(help: "POEditor read token")
    var token: String
    
    @Option(help: "POEditor project id")
    var project_id: String
    
    @Option(help: "output directory path")
    var output : Path
    
    /// Configuration for ParsableCommand
    public static let configuration = CommandConfiguration(
        commandName: "export",
        abstract: "Export tool",
        version: "2.0.0"
    )
    
    public init() {}
    
    public func run() async throws {
        
        print("🚀 Starting generating POEditor translations files")
        print("> token=\(token)")
        print("> project_id=\(project_id)")
        print("> output=\(output)")
        
        
        let apiHandler = POEditorAPIHandler(token: token, projectId: project_id)
        
        // Get the languages liste
        let languages = try await apiHandler.getLanguages()
        
        // Create a progressBar
        var progressBar = ProgressBar(count: languages.count)
        
        // Create the target directories
        try languages.forEach {
            let targetDirectory = $0.getTargetDirectory(from: output)
            try FileManager.default.createDirectory(at: targetDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        // Storage for failures
        let failureStore = FailureStore()
        
        // Loop async on all the language to
        // - get translation file URL
        // - download the file
        // - create the InfoPlist.strings
        await withTaskGroup(of: Void.self){ group in
            
            for language in languages {
               
                _ = group.addTaskUnlessCancelled {
                    do {
                        let url = try await apiHandler.getTranslationFileURL(language: language.code, type: .appleStrings)
                        
                        let translationFileUrl = language.getTargetTranslationFile(from: output)
                        
                        // Delete any existing translationFile
                        if FileManager.default.fileExists(atPath: translationFileUrl.path) {
                            try FileManager.default.removeItem(at: translationFileUrl)
                        }
                        
                        // Download the file
                        try await download(url: url, to: translationFileUrl)
                        
                        
                        // Adds InfoPlist.strings by filtering NS and CS translations
                        if let allTranslations = NSDictionary(contentsOfFile: translationFileUrl.path) as? [String:Any] {
                            let infoPlistTranslations = allTranslations.filter { $0.key.starts(with: "NS") || $0.key.starts(with: "CF") }
                            let nsDic = NSDictionary(dictionary: infoPlistTranslations)
                            let str = nsDic.descriptionInStringsFileFormat
                            
                            let targetDirectory = language.getTargetDirectory(from: output)
                            let infoPlistStringFile = targetDirectory.appendingPathComponent("InfoPlist.strings")
                            try str.write(to: infoPlistStringFile, atomically: true, encoding: .utf8)
                        }
                        
                    }
                    catch {
                        await failureStore.append(language)
                    }
                    
                }
                
                // Update progressBar
                for await _ in group {
                    progressBar.next()
                }
            }
            
            
            // Display final result
            let failedItems = await failureStore.items
            
            if !failedItems.isEmpty {
                print("☠️ Download(s) failed on \(failedItems.map { $0.code })")
            }
            else {
                print("🏁 Export successfull")
            }
        }
        
        
    }
    
    
    private func download(url : URL, to: URL) async throws {
        let urlRequest = URLRequest(url: url)
        let tempURL = try await API.download(urlRequest: urlRequest)
        
        //on le copie à destination
        try FileManager.default.moveItem(at: tempURL, to: to)
    }
}
    
// On créé un FailureStore actor afin qu'on puisse stocker les recording qui ont échoués
fileprivate actor FailureStore {
    var items = [Language]()
    
    func append(_ language : Language){
        items.append(language)
    }
}
