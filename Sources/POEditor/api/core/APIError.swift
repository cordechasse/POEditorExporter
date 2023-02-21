//
//  Created by Nicolas Bush on 19/02/2023.
//

import Foundation

enum APIError : Error {
    case URLGenerationFailure
    case expectationFailed(description : String)
    case serverError(urlRequest: URLRequest, statusCode: HTTPStatusCode, rawResponse: Data?)
    case downloadFailure(description : String)
}
