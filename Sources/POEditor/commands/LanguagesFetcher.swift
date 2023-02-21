//
//  File.swift
//  
//
//  Created by Nicolas Bush on 19/02/2023.
//

import Foundation


protocol LanguagesFetcher {
    
    func getLanguages() async throws -> [Language]
}
