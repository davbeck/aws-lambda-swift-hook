import Foundation


public enum Result<T> {
	case success(T)
	case error(Error)
}
