//
// Created by Nicolas Bush on 28/02/2022.
// Copyright (c) 2022 Nicolas Bush. All rights reserved.
//

import Foundation

extension NSMutableData {
	func append(_ string: String) {
		if let data = string.data(using: .utf8) {
			self.append(data)
		}
	}
}
