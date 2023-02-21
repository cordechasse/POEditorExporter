//
//  Created by Nicolas Bush on 21/02/2023.
//

import Foundation
import Path

extension Language {
    
    func getTargetDirectory(from output: Path) -> URL {
        output.url.appendingPathComponent("\(code).lproj", isDirectory: true)
    }
    
    func getTargetTranslationFile(from output: Path) -> URL {
        let directory = getTargetDirectory(from: output)
        return directory.appendingPathComponent("Localizable.strings")
    }
    
}
