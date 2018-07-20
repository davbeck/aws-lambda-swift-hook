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

struct Console {
	func log(_ output: String) {
		print(output)
		fflush(stdout)
	}
	
	func error(_ output: String) {
		var standardError = FileHandle.standardError
		print(output, to: &standardError)
		fflush(stderr)
	}
	
	func error(_ output: Swift.Error) {
		self.error(output.localizedDescription)
	}
}
let console = Console()
