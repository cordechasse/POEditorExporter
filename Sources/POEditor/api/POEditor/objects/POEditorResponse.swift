//
//  Created by Nicolas Bush on 19/02/2023.
//

import Foundation


struct POEditorResponse<T : Decodable> {
    var response : ResponseInfo
    var result : T
}

extension POEditorResponse : Decodable {}

struct ResponseInfo : Decodable {
    var status: String
    var code : String
    var message : String
}
