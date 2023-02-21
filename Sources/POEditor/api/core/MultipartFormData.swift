//
// Created by Nicolas Bush on 28/02/2022.
// Copyright (c) 2022 Nicolas Bush. All rights reserved.
//

import Foundation

public protocol MultipartFormDataObject {
	func getField(boundary: String) -> Data
}



public struct MultipartFormDataFile: MultipartFormDataObject {
	
	var name : String
	var filename : String
	var mimeType : String
	var data : Data
	
    
    public init(name : String, filename : String, mimeType : String, data : Data) {
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
        self.data = data
    }
    
    public func getField(boundary: String) -> Data {
		
		let fieldData = NSMutableData()
		fieldData.append("--\(boundary)\r\n")
		fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
		fieldData.append("Content-Type: \(mimeType)\r\n")
		fieldData.append("\r\n")
		fieldData.append(data)
		fieldData.append("\r\n")
	
		return fieldData as Data
	}
}



public struct MultipartFormDataText : MultipartFormDataObject {
	
	var name : String
	var value : String
	
    public init(name : String, value : String) {
        self.name = name
        self.value = value
    }
    
    
    public func getField(boundary: String) -> Data {
		
		let fieldData = NSMutableData()
		fieldData.append("--\(boundary)\r\n")
		fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
		fieldData.append("Content-Type: text/plain; charset=ISO-8859-1\r\n")
		fieldData.append("Content-Transfer-Encoding: 8bit\r\n")
		fieldData.append("\r\n")
		fieldData.append("\(value)\r\n")
		
		return fieldData as Data
	}
}
