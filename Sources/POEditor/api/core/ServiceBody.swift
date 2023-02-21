//
// Created by Nicolas Bush on 17/11/2021.
// Copyright (c) 2021 Nicolas Bush. All rights reserved.
//

import Foundation

public enum ServiceBody {
	case json(value : Encodable)
	case data(value : Data, contentType: String)
	case multipartFormData(values: [MultipartFormDataObject])
    case formData(values : [URLQueryItem])
}
