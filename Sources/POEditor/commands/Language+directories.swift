//
//  Created by Nicolas Bush on 21/02/2023.
//

import Foundation

extension Language {
    
    func getTargetDirectory(from output: URL) -> URL {
        output.appendingPathComponent("\(code).lproj", isDirectory: true)
    }
    
    func getTargetTranslationFile(from output: URL) -> URL {
        let directory = getTargetDirectory(from: output)
        return directory.appendingPathComponent("Localizable.strings")
    }
    
}
