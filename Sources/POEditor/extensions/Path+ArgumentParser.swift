//
//  Created by Nicolas Bush on 25/08/2022.
//

import Foundation
import Path
import ArgumentParser

extension Path : ExpressibleByArgument {
    public init?(argument: String) {
        self.init(argument)
    }
}
