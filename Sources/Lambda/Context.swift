import Foundation


public struct Context: Codable, Equatable {
	public var functionName: String?
	public var requestID: String?
	public var invokedFunctionArn: String?
	
	public enum CodingKeys: String, CodingKey {
		case functionName = "functionName"
		case requestID = "awsRequestId"
		case invokedFunctionArn = "invokedFunctionArn"
	}
}
