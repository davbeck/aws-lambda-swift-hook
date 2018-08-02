import Foundation
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif


extension FileHandle : TextOutputStream {
	public func write(_ string: String) {
		guard let data = string.data(using: .utf8) else { return }
		self.write(data)
	}
}

public struct Console {
	public func log(_ output: String) {
		print(output)
		fflush(stdout)
	}
	
	public func error(_ output: String) {
		var standardError = FileHandle.standardError
		print(output, to: &standardError)
		fflush(stderr)
	}
	
	public func error(_ output: Swift.Error) {
		self.error(output.localizedDescription)
	}
}
public let console = Console()
