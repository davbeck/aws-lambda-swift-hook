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
	public var httpMethod: String = ""
	public var headers: [String:String] = [:]
	public var queryStringParameters: [String:String] = [:]
	public var pathParameters: [String:String] = [:]
	public var stageVariables: [String:String] = [:]
	public var requestContext: APIGatewayProxyRequestContext = APIGatewayProxyRequestContext()
	public var body: String = ""
	public var isBase64Encoded: Bool = false
	
	public init(
		httpMethod: String = "",
		headers: [String:String] = [:],
		queryStringParameters: [String:String] = [:],
		pathParameters: [String:String] = [:],
		stageVariables: [String:String] = [:],
		requestContext: APIGatewayProxyRequestContext = APIGatewayProxyRequestContext(),
		body: String = "",
		isBase64Encoded: Bool = false
		) {
		self.httpMethod = httpMethod
		self.headers = headers
		self.queryStringParameters = queryStringParameters
		self.pathParameters = pathParameters
		self.stageVariables = stageVariables
		self.requestContext = requestContext
		self.body = body
		self.isBase64Encoded = isBase64Encoded
	}
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.httpMethod = (try? container.decode(String.self, forKey: .httpMethod)) ?? ""
		self.headers = (try? container.decode([String:String].self, forKey: .headers)) ?? [:]
		self.queryStringParameters = (try? container.decode([String:String].self, forKey: .queryStringParameters)) ?? [:]
		self.pathParameters = (try? container.decode([String:String].self, forKey: .pathParameters)) ?? [:]
		self.stageVariables = (try? container.decode([String:String].self, forKey: .stageVariables)) ?? [:]
		self.requestContext = (try? container.decode(APIGatewayProxyRequestContext.self, forKey: .requestContext)) ?? APIGatewayProxyRequestContext()
		self.body = (try? container.decode(String.self, forKey: .body)) ?? ""
		self.isBase64Encoded = (try? container.decode(Bool.self, forKey: .isBase64Encoded)) ?? false
	}
	
	public enum CodingKeys: String, CodingKey {
		case httpMethod = "httpMethod"
		case headers = "headers"
		case queryStringParameters = "queryStringParameters"
		case pathParameters = "pathParameters"
		case stageVariables = "stageVariables"
		case requestContext = "requestContext"
		case body = "body"
		case isBase64Encoded = "isBase64Encoded"
	}
}

public struct APIGatewayProxyResponse: Codable, Equatable, BodyEvent {
	public var statusCode: Int = 200
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
		self.init(statusCode: statusCode, headers: headers, body: body.base64EncodedString(), isBase64Encoded: true)
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.statusCode = (try? container.decode(Int.self, forKey: .statusCode)) ?? 0
		self.headers = (try? container.decode([String:String].self, forKey: .headers)) ?? [:]
		self.body = (try? container.decode(String.self, forKey: .body)) ?? ""
		self.isBase64Encoded = (try? container.decode(Bool.self, forKey: .isBase64Encoded)) ?? false
	}
	
	public enum CodingKeys: String, CodingKey {
		case statusCode = "statusCode"
		case headers = "headers"
		case body = "body"
		case isBase64Encoded = "isBase64Encoded"
	}
}

public struct APIGatewayProxyRequestContext: Codable, Equatable {
	public var accountID: String = ""
	public var resourceID: String = ""
	public var stage: String = ""
	public var requestID: String = ""
	public var identity: APIGatewayRequestIdentity = APIGatewayRequestIdentity()
	public var resourcePath: String = ""
	// Codable doesn't support this yet
	// public var authorizer: [String:Any] = [:]
	
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.accountID = (try? container.decode(String.self, forKey: .accountID)) ?? ""
		self.resourceID = (try? container.decode(String.self, forKey: .resourceID)) ?? ""
		self.stage = (try? container.decode(String.self, forKey: .stage)) ?? ""
		self.requestID = (try? container.decode(String.self, forKey: .requestID)) ?? ""
		self.identity = (try? container.decode(APIGatewayRequestIdentity.self, forKey: .identity)) ?? APIGatewayRequestIdentity()
		self.resourcePath = (try? container.decode(String.self, forKey: .resourcePath)) ?? ""
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.cognitoIdentityPoolID = (try? container.decode(String.self, forKey: .cognitoIdentityPoolID)) ?? ""
		self.accountID = (try? container.decode(String.self, forKey: .accountID)) ?? ""
		self.cognitoIdentityID = (try? container.decode(String.self, forKey: .cognitoIdentityID)) ?? ""
		self.caller = (try? container.decode(String.self, forKey: .caller)) ?? ""
		self.aPIKey = (try? container.decode(String.self, forKey: .aPIKey)) ?? ""
		self.sourceIP = (try? container.decode(String.self, forKey: .sourceIP)) ?? ""
		self.cognitoAuthenticationType = (try? container.decode(String.self, forKey: .cognitoAuthenticationType)) ?? ""
		self.cognitoAuthenticationProvider = (try? container.decode(String.self, forKey: .cognitoAuthenticationProvider)) ?? ""
		self.userArn = (try? container.decode(String.self, forKey: .userArn)) ?? ""
		self.userAgent = (try? container.decode(String.self, forKey: .userAgent)) ?? ""
		self.user = (try? container.decode(String.self, forKey: .user)) ?? ""
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.aPIKey = (try? container.decode(String.self, forKey: .aPIKey)) ?? ""
		self.sourceIP = (try? container.decode(String.self, forKey: .sourceIP)) ?? ""
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.principalID = (try? container.decode(String.self, forKey: .principalID)) ?? ""
		self.stringKey = (try? container.decode(String.self, forKey: .stringKey)) ?? ""
		self.numKey = (try? container.decode(Int.self, forKey: .numKey)) ?? 0
		self.boolKey = (try? container.decode(Bool.self, forKey: .boolKey)) ?? false
	}
	
	public enum CodingKeys: String, CodingKey {
		case principalID = "principalId"
		case stringKey = "stringKey"
		case numKey = "numKey"
		case boolKey = "boolKey"
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
	public var httpMethod: String = ""
	public var aPIID: String = ""
	
	public init(
		path: String = "",
		accountID: String = "",
		resourceID: String = "",
		stage: String = "",
		requestID: String = "",
		identity: APIGatewayCustomAuthorizerRequestTypeRequestIdentity = APIGatewayCustomAuthorizerRequestTypeRequestIdentity(),
		resourcePath: String = "",
		httpMethod: String = "",
		aPIID: String = ""
		) {
		self.path = path
		self.accountID = accountID
		self.resourceID = resourceID
		self.stage = stage
		self.requestID = requestID
		self.identity = identity
		self.resourcePath = resourcePath
		self.httpMethod = httpMethod
		self.aPIID = aPIID
	}
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.path = (try? container.decode(String.self, forKey: .path)) ?? ""
		self.accountID = (try? container.decode(String.self, forKey: .accountID)) ?? ""
		self.resourceID = (try? container.decode(String.self, forKey: .resourceID)) ?? ""
		self.stage = (try? container.decode(String.self, forKey: .stage)) ?? ""
		self.requestID = (try? container.decode(String.self, forKey: .requestID)) ?? ""
		self.identity = (try? container.decode(APIGatewayCustomAuthorizerRequestTypeRequestIdentity.self, forKey: .identity)) ?? APIGatewayCustomAuthorizerRequestTypeRequestIdentity()
		self.resourcePath = (try? container.decode(String.self, forKey: .resourcePath)) ?? ""
		self.httpMethod = (try? container.decode(String.self, forKey: .httpMethod)) ?? ""
		self.aPIID = (try? container.decode(String.self, forKey: .aPIID)) ?? ""
	}
	
	public enum CodingKeys: String, CodingKey {
		case path = "path"
		case accountID = "accountId"
		case resourceID = "resourceId"
		case stage = "stage"
		case requestID = "requestId"
		case identity = "identity"
		case resourcePath = "resourcePath"
		case httpMethod = "httpMethod"
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
		self.authorizationToken = (try? container.decode(String.self, forKey: .authorizationToken)) ?? ""
		self.methodArn = (try? container.decode(String.self, forKey: .methodArn)) ?? ""
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
	public var httpMethod: String = ""
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
		httpMethod: String = "",
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
		self.httpMethod = httpMethod
		self.headers = headers
		self.queryStringParameters = queryStringParameters
		self.pathParameters = pathParameters
		self.stageVariables = stageVariables
		self.requestContext = requestContext
	}
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
		self.methodArn = (try? container.decode(String.self, forKey: .methodArn)) ?? ""
		self.resource = (try? container.decode(String.self, forKey: .resource)) ?? ""
		self.path = (try? container.decode(String.self, forKey: .path)) ?? ""
		self.httpMethod = (try? container.decode(String.self, forKey: .httpMethod)) ?? ""
		self.headers = (try? container.decode([String:String].self, forKey: .headers)) ?? [:]
		self.queryStringParameters = (try? container.decode([String:String].self, forKey: .queryStringParameters)) ?? [:]
		self.pathParameters = (try? container.decode([String:String].self, forKey: .pathParameters)) ?? [:]
		self.stageVariables = (try? container.decode([String:String].self, forKey: .stageVariables)) ?? [:]
		self.requestContext = (try? container.decode(APIGatewayCustomAuthorizerRequestTypeRequestContext.self, forKey: .requestContext)) ?? APIGatewayCustomAuthorizerRequestTypeRequestContext()
	}
	
	public enum CodingKeys: String, CodingKey {
		case type = "type"
		case methodArn = "methodArn"
		case resource = "resource"
		case path = "path"
		case httpMethod = "httpMethod"
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
	// Codable doesn't support this yet
	// public var context: [String:Any] = [:]
	
	public init(
		principalID: String = "",
		policyDocument: APIGatewayCustomAuthorizerPolicy = APIGatewayCustomAuthorizerPolicy()
		) {
		self.principalID = principalID
		self.policyDocument = policyDocument
	}
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.principalID = (try? container.decode(String.self, forKey: .principalID)) ?? ""
		self.policyDocument = (try? container.decode(APIGatewayCustomAuthorizerPolicy.self, forKey: .policyDocument)) ?? APIGatewayCustomAuthorizerPolicy()
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.version = (try? container.decode(String.self, forKey: .version)) ?? ""
		self.statement = (try? container.decode([IAMPolicyStatement].self, forKey: .statement)) ?? [IAMPolicyStatement]()
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
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.action = (try? container.decode([String].self, forKey: .action)) ?? [String]()
		self.effect = (try? container.decode(String.self, forKey: .effect)) ?? ""
		self.resource = (try? container.decode([String].self, forKey: .resource)) ?? [String]()
	}
	
	public enum CodingKeys: String, CodingKey {
		case action = "Action"
		case effect = "Effect"
		case resource = "Resource"
	}
}

