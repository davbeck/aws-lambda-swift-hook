import Foundation


extension Swift.Error {
	func jsonData() -> Data {
		var errorObject: [String:Any] = [
			"description":self.localizedDescription
		]
		if let error = self as? CustomNSError {
			errorObject["code"] = error.errorCode
			errorObject["domain"] = type(of: error).errorDomain
			errorObject["userInfo"] = error.errorUserInfo
		} else {
			errorObject["type"] = String(describing: type(of: self))
		}
		
		return (try? JSONSerialization.data(withJSONObject: errorObject)) ??
			"\"\(self.localizedDescription)\"".data(using: .utf8) ??
			Data()
	}
}
