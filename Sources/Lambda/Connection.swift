import Foundation
import Socket


public class Connection {
	public enum Error: Swift.Error {
		case endOfStream
	}
	
	public enum ResultType: UInt8 {
		case success = 1
		case error = 2
	}
	
	
	private let socket: Socket
	private var buffer = Data()
	public let decoder = JSONDecoder()
	public let encoder = JSONEncoder()
	
	public init() throws {
		socket = try Socket.create(family: .unix, type: .stream, proto: .unix)
	}
	
	private func connect() throws {
		try socket.connect(to: "/tmp/swift.sock")
	}
	
	private func read(count: Int) throws -> Data {
		while buffer.count < count {
			var newData = Data()
			let newCount = try socket.read(into: &newData)
			buffer.append(newData)
			
			if newCount <= 0 {
				break
			}
		}
		
		if buffer.count < count {
			throw Error.endOfStream
		}
		
		let chunk = buffer.prefix(count)
		buffer.removeFirst(count)
		
		return chunk
	}
	
	private func readUInt32() throws -> UInt32 {
		let data = try self.read(count: 4)
		
		return data.withUnsafeBytes({ UInt32(bigEndian: $0.pointee) })
	}
	
	private func readJSON() throws -> Data {
		let count = try self.readUInt32()
		let data = try self.read(count: Int(count))
		
		return data
	}
	
	private func write(_ data: Data) throws {
		try self.socket.write(from: data)
	}
	
	private func write<T: FixedWidthInteger>(_ value: T) throws {
		var value = value.bigEndian
		let bufSize = value.bitWidth / UInt8.bitWidth
		_ = try withUnsafeBytes(of: &value) { (pointer) in
			try self.socket.write(from: pointer.baseAddress!, bufSize: bufSize)
		}
	}
	
	private func write(json: Data) throws {
		try self.write(UInt32(json.count))
		try self.write(json)
	}
	
	
	public func start(_ handler: (Context, Data, @escaping (Result<Data>) -> Void) throws -> Void) throws {
		try connect()
		
		while true {
			do {
				let contextData = try self.readJSON()
				let context = try decoder.decode(Context.self, from: contextData)
				
				let payloadData = try self.readJSON()
				
				try handler(context, payloadData) { result in
					switch result {
					case .success(let output):
						try! self.write(Connection.ResultType.success.rawValue)
						try! self.write(json: output)
					case .error(let error):
						console.error(error)
						try! self.write(Connection.ResultType.error.rawValue)
						try! self.write(json: error.jsonData())
					}
				}
			} catch {
				console.error(error)
				try! self.write(Connection.ResultType.error.rawValue)
			}
		}
	}
	
	public func start<Input: Decodable, Output: Encodable>(_ handler: (Context, Input, @escaping (Result<Output>) -> Void) throws -> Void) throws {
		try self.start { (context, inputData: Data, completion: @escaping (Result<Data>) -> Void) in
			let input = try decoder.decode(Input.self, from: inputData)
			
			try handler(context, input) { result in
				switch result {
				case .success(let output):
					let outputData = try! self.encoder.encode(output)
					completion(.success(outputData))
				case .error(let error):
					completion(.error(error))
				}
			}
		}
	}
}


public func start<Input: Decodable, Output: Encodable>(_ handler: (Context, Input, @escaping (Result<Output>) -> Void) throws -> Void) {
	do {
		let server = try Connection()
		try server.start(handler)
	} catch {
		console.error(error)
		fatalError("failed to setup connection")
	}
}
