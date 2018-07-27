// this file was originally generated based on the Go implimentation
// https://github.com/aws/aws-lambda-go/blob/master/events/apigw.go

import Foundation


public protocol BodyEvent {
	var body: String { get set }
	var isBase64Encoded: Bool { get set }
	var data: Data { get set }
}

extension BodyEvent {
	public var data: Data {
		get {
			if isBase64Encoded {
				return Data(base64Encoded: body) ?? Data()
			} else {
				return body.data(using: .utf8) ?? Data()
			}
		}
		set {
			isBase64Encoded = true
			body = newValue.base64EncodedString()
		}
	}
}


public struct APIGatewayProxyRequest: Codable, Equatable, BodyEvent {
	public var hTTPMethod: String = ""
	public var headers: [String:String] = [:]
	public var queryStringParameters: [String:String] = [:]
	public var pathParameters: [String:String] = [:]
	public var stageVariables: [String:String] = [:]
	public var requestContext: APIGatewayProxyRequestContext = APIGatewayProxyRequestContext()
	public var body: String = ""
	public var isBase64Encoded: Bool = false
	
	public init(
		hTTPMethod: String = "",
		headers: [String:String] = [:],
		queryStringParameters: [String:String] = [:],
		pathParameters: [String:String] = [:],
		stageVariables: [String:String] = [:],
		requestContext: APIGatewayProxyRequestContext = APIGatewayProxyRequestContext(),
		body: String = "",
		isBase64Encoded: Bool = false
		) {
		self.hTTPMethod = hTTPMethod
		self.headers = headers
		self.queryStringParameters = queryStringParameters
		self.pathParameters = pathParameters
		self.stageVariables = stageVariables
		self.requestContext = requestContext
		self.body = body
		self.isBase64Encoded = isBase64Encoded
	}
	
	public enum CodingKeys: String, CodingKey {
		case hTTPMethod = "httpMethod"
		case headers = "headers"
		case queryStringParameters = "queryStringParameters"
		case pathParameters = "pathParameters"
		case stageVariables = "stageVariables"
		case requestContext = "requestContext"
		case body = "body"
		case isBase64Encoded = "isBase64Encoded,omitempty"
	}
}

public struct APIGatewayProxyResponse: Codable, Equatable, BodyEvent {
	public var statusCode: Int = 0
	public var headers: [String:String] = [:]
	public var body: String = ""
	public var isBase64Encoded: Bool = false
	
	public init(
		statusCode: Int = 200,
		headers: [String:String] = [:],
		body: String = "",
		isBase64Encoded: Bool = false
		) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = body
		self.isBase64Encoded = isBase64Encoded
	}
	
	public init(
		statusCode: Int = 200,
		headers: [String:String] = [:],
		body: Data
		) {
		self.init(
			statusCode: statusCode,
			headers: headers,
			body: body.base64EncodedString(),
			isBase64Encoded: true
		)
	}
	
	public enum CodingKeys: String, CodingKey {
		case statusCode = "statusCode"
		case headers = "headers"
		case body = "body"
		case isBase64Encoded = "isBase64Encoded,omitempty"
	}
}


public struct APIGatewayProxyRequestContext: Codable, Equatable {
	public var accountID: String = ""
	public var resourceID: String = ""
	public var stage: String = ""
	public var requestID: String = ""
	public var identity: APIGatewayRequestIdentity = APIGatewayRequestIdentity()
	public var resourcePath: String = ""
	// TODO: Codable doesn't support untyped dictionaries
	// we could make it generic, but then it would need to be specified even if it wasn't being used
	// public var authorizer: [String:Any]
	
	public init(
		accountID: String = "",
		resourceID: String = "",
		stage: String = "",
		requestID: String = "",
		identity: APIGatewayRequestIdentity = APIGatewayRequestIdentity(),
		resourcePath: String = ""
	) {
		self.accountID = accountID
		self.resourceID = resourceID
		self.stage = stage
		self.requestID = requestID
		self.identity = identity
		self.resourcePath = resourcePath
	}
	
	public enum CodingKeys: String, CodingKey {
		case accountID = "accountId"
		case resourceID = "resourceId"
		case stage = "stage"
		case requestID = "requestId"
		case identity = "identity"
		case resourcePath = "resourcePath"
	}
}

public struct APIGatewayRequestIdentity: Codable, Equatable {
	public var cognitoIdentityPoolID: String = ""
	public var accountID: String = ""
	public var cognitoIdentityID: String = ""
	public var caller: String = ""
	public var aPIKey: String = ""
	public var sourceIP: String = ""
	public var cognitoAuthenticationType: String = ""
	public var cognitoAuthenticationProvider: String = ""
	public var userArn: String = ""
	public var userAgent: String = ""
	public var user: String = ""
	
	public init(
		cognitoIdentityPoolID: String = "",
		accountID: String = "",
		cognitoIdentityID: String = "",
		caller: String = "",
		aPIKey: String = "",
		sourceIP: String = "",
		cognitoAuthenticationType: String = "",
		cognitoAuthenticationProvider: String = "",
		userArn: String = "",
		userAgent: String = "",
		user: String = ""
		) {
		self.cognitoIdentityPoolID = cognitoIdentityPoolID
		self.accountID = accountID
		self.cognitoIdentityID = cognitoIdentityID
		self.caller = caller
		self.aPIKey = aPIKey
		self.sourceIP = sourceIP
		self.cognitoAuthenticationType = cognitoAuthenticationType
		self.cognitoAuthenticationProvider = cognitoAuthenticationProvider
		self.userArn = userArn
		self.userAgent = userAgent
		self.user = user
	}
	
	public enum CodingKeys: String, CodingKey {
		case cognitoIdentityPoolID = "cognitoIdentityPoolId"
		case accountID = "accountId"
		case cognitoIdentityID = "cognitoIdentityId"
		case caller = "caller"
		case aPIKey = "apiKey"
		case sourceIP = "sourceIp"
		case cognitoAuthenticationType = "cognitoAuthenticationType"
		case cognitoAuthenticationProvider = "cognitoAuthenticationProvider"
		case userArn = "userArn"
		case userAgent = "userAgent"
		case user = "user"
	}
}

public struct APIGatewayCustomAuthorizerRequestTypeRequestIdentity: Codable, Equatable {
	public var aPIKey: String = ""
	public var sourceIP: String = ""
	
	public init(
		aPIKey: String = "",
		sourceIP: String = ""
		) {
		self.aPIKey = aPIKey
		self.sourceIP = sourceIP
	}
	
	public enum CodingKeys: String, CodingKey {
		case aPIKey = "apiKey"
		case sourceIP = "sourceIp"
	}
}

public struct APIGatewayCustomAuthorizerContext: Codable, Equatable {
	public var principalID: String = ""
	public var stringKey: String = ""
	public var numKey: Int = 0
	public var boolKey: Bool = false
	
	public init(
		principalID: String = "",
		stringKey: String = "",
		numKey: Int = 0,
		boolKey: Bool = false
		) {
		self.principalID = principalID
		self.stringKey = stringKey
		self.numKey = numKey
		self.boolKey = boolKey
	}
	
	public enum CodingKeys: String, CodingKey {
		case principalID = "principalId"
		case stringKey = "stringKey,omitempty"
		case numKey = "numKey,omitempty"
		case boolKey = "boolKey,omitempty"
	}
}

public struct APIGatewayCustomAuthorizerRequestTypeRequestContext: Codable, Equatable {
	public var path: String = ""
	public var accountID: String = ""
	public var resourceID: String = ""
	public var stage: String = ""
	public var requestID: String = ""
	public var identity: APIGatewayCustomAuthorizerRequestTypeRequestIdentity = APIGatewayCustomAuthorizerRequestTypeRequestIdentity()
	public var resourcePath: String = ""
	public var hTTPMethod: String = ""
	public var aPIID: String = ""
	
	public init(
		path: String = "",
		accountID: String = "",
		resourceID: String = "",
		stage: String = "",
		requestID: String = "",
		identity: APIGatewayCustomAuthorizerRequestTypeRequestIdentity = APIGatewayCustomAuthorizerRequestTypeRequestIdentity(),
		resourcePath: String = "",
		hTTPMethod: String = "",
		aPIID: String = ""
		) {
		self.path = path
		self.accountID = accountID
		self.resourceID = resourceID
		self.stage = stage
		self.requestID = requestID
		self.identity = identity
		self.resourcePath = resourcePath
		self.hTTPMethod = hTTPMethod
		self.aPIID = aPIID
	}
	
	public enum CodingKeys: String, CodingKey {
		case path = "path"
		case accountID = "accountId"
		case resourceID = "resourceId"
		case stage = "stage"
		case requestID = "requestId"
		case identity = "identity"
		case resourcePath = "resourcePath"
		case hTTPMethod = "httpMethod"
		case aPIID = "apiId"
	}
}

public struct APIGatewayCustomAuthorizerRequest: Codable, Equatable {
	public var type: String = ""
	public var authorizationToken: String = ""
	public var methodArn: String = ""
	
	public init(
		type: String = "",
		authorizationToken: String = "",
		methodArn: String = ""
		) {
		self.type = type
		self.authorizationToken = authorizationToken
		self.methodArn = methodArn
	}
	
	public enum CodingKeys: String, CodingKey {
		case type = "type"
		case authorizationToken = "authorizationToken"
		case methodArn = "methodArn"
	}
}

public struct APIGatewayCustomAuthorizerRequestTypeRequest: Codable, Equatable {
	public var type: String = ""
	public var methodArn: String = ""
	public var resource: String = ""
	public var path: String = ""
	public var hTTPMethod: String = ""
	public var headers: [String:String] = [:]
	public var queryStringParameters: [String:String] = [:]
	public var pathParameters: [String:String] = [:]
	public var stageVariables: [String:String] = [:]
	public var requestContext: APIGatewayCustomAuthorizerRequestTypeRequestContext = APIGatewayCustomAuthorizerRequestTypeRequestContext()
	
	public init(
		type: String = "",
		methodArn: String = "",
		resource: String = "",
		path: String = "",
		hTTPMethod: String = "",
		headers: [String:String] = [:],
		queryStringParameters: [String:String] = [:],
		pathParameters: [String:String] = [:],
		stageVariables: [String:String] = [:],
		requestContext: APIGatewayCustomAuthorizerRequestTypeRequestContext = APIGatewayCustomAuthorizerRequestTypeRequestContext()
		) {
		self.type = type
		self.methodArn = methodArn
		self.resource = resource
		self.path = path
		self.hTTPMethod = hTTPMethod
		self.headers = headers
		self.queryStringParameters = queryStringParameters
		self.pathParameters = pathParameters
		self.stageVariables = stageVariables
		self.requestContext = requestContext
	}
	
	public enum CodingKeys: String, CodingKey {
		case type = "type"
		case methodArn = "methodArn"
		case resource = "resource"
		case path = "path"
		case hTTPMethod = "httpMethod"
		case headers = "headers"
		case queryStringParameters = "queryStringParameters"
		case pathParameters = "pathParameters"
		case stageVariables = "stageVariables"
		case requestContext = "requestContext"
	}
}

public struct APIGatewayCustomAuthorizerResponse: Codable, Equatable {
	public var principalID: String = ""
	public var policyDocument: APIGatewayCustomAuthorizerPolicy = APIGatewayCustomAuthorizerPolicy()
	// ther is currently no way to represent Any with Codable
	// public var context: [String:Any] = [:]
	
	public init(
		principalID: String = "",
		policyDocument: APIGatewayCustomAuthorizerPolicy = APIGatewayCustomAuthorizerPolicy()
		) {
		self.principalID = principalID
		self.policyDocument = policyDocument
	}
	
	public enum CodingKeys: String, CodingKey {
		case principalID = "principalId"
		case policyDocument = "policyDocument"
	}
}

public struct APIGatewayCustomAuthorizerPolicy: Codable, Equatable {
	public var version: String = ""
	public var statement: [IAMPolicyStatement] = []
	
	public init(
		version: String = "",
		statement: [IAMPolicyStatement] = []
		) {
		self.version = version
		self.statement = statement
	}
	
	public enum CodingKeys: String, CodingKey {
		case version = "Version"
		case statement = "Statement"
	}
}

public struct IAMPolicyStatement: Codable, Equatable {
	public var action: [String] = []
	public var effect: String = ""
	public var resource: [String] = []
	
	public init(
		action: [String] = [],
		effect: String = "",
		resource: [String] = []
		) {
		self.action = action
		self.effect = effect
		self.resource = resource
	}
	
	public enum CodingKeys: String, CodingKey {
		case action = "Action"
		case effect = "Effect"
		case resource = "Resource"
	}
}

